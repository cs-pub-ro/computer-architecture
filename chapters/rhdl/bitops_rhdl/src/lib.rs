use proc_macro::TokenStream;
use quote::quote;
use syn::{
    fold::Fold, parse_macro_input, GenericArgument, Expr, ExprIndex, ExprMethodCall, ExprRange,
    ItemFn, Lit, Type,
};

struct IndexExpander;

impl Fold for IndexExpander {
    fn fold_expr(&mut self, expr: Expr) -> Expr {
        // Recurse first so that i[a..b] -> .xshr().resize()
        let expr = syn::fold::fold_expr(self, expr);

        // ---- Detect tuple of only `.resize::<T>()` ----
        if let Expr::Tuple(tuple) = &expr {
            let mut resize_types = Vec::<Type>::new();
            let mut resize_exprs = Vec::<Expr>::new();
            let mut all_match = true;

            for elem in &tuple.elems {
                match elem {
                    Expr::MethodCall(ExprMethodCall {
                        method,
                        turbofish: Some(turbofish),
                        ..
                    }) if method == "resize" => {
                        let mut found_type = None;
                        for arg in &turbofish.args {
                            if let GenericArgument::Type(ty) = arg {
                                found_type = Some(ty.clone());
                                break;
                            }
                        }
                        if let Some(ty) = found_type {
                            resize_types.push(ty);
                            resize_exprs.push(elem.clone());
                        } else {
                            all_match = false;
                            break;
                        }
                    }
                    _ => {
                        all_match = false;
                        break;
                    }
                }
            }

            if all_match && !resize_types.is_empty() {
                // ---- Build the folded expression ----
                let mut build_expr = resize_exprs[0].clone();
                let mut build_type = resize_types[0].clone();

                for (expr_i, ty_i) in resize_exprs.iter().zip(resize_types.iter()).skip(1) {
                    let next_build_type: Type =
                        syn::parse_quote!(Sum<#build_type, #ty_i>);
                    let next_expr: Expr = syn::parse_quote! {
                        ((#build_expr).xshl::<#ty_i>() | (#expr_i).resize::<#next_build_type>())
                    };
                    build_expr = next_expr;
                    build_type = next_build_type;
                }

                return build_expr;
            }
        }

        // ---- Normal index -> .xshr().resize() expansion ----
        if let Expr::Index(ExprIndex { expr: base, index, .. }) = &expr {
            if let Expr::Range(ExprRange { start, end, .. }) = &**index {
                if let (Some(start_expr), Some(end_expr)) = (start, end) {
                    if let (Expr::Lit(start_lit), Expr::Lit(end_lit)) =
                        (&**start_expr, &**end_expr)
                    {
                        if let (Lit::Int(start_int), Lit::Int(end_int)) =
                            (&start_lit.lit, &end_lit.lit)
                        {
                            let a: u32 = start_int.base10_parse().unwrap();
                            let b: u32 = end_int.base10_parse().unwrap();
                            let ua = syn::Ident::new(&format!("U{}", a), start_int.span());
                            let ub = syn::Ident::new(&format!("U{}", b), end_int.span());

                            let expanded = if a == b && b == 0 {
                                quote! { (#base).resize::<U1>() }
                            } else if b == 0 {
                                quote! { (#base).resize::<Add1<#ua>>() }
                            } else if a == b {
                                quote! { (#base).xshr::<#ub>().resize::<U1>() }
                            } else {
                                quote! { (#base).xshr::<#ub>().resize::<Add1<Diff<#ua, #ub>>>() }
                            };
                            return syn::parse2(expanded).unwrap();
                        }
                    }
                }
            }

            if let Expr::Lit(lit_expr) = &**index {
                if let Lit::Int(b_int) = &lit_expr.lit {
                    let b: u32 = b_int.base10_parse().unwrap();
                    let ub = syn::Ident::new(&format!("U{}", b), b_int.span());
                    let expanded = if b == 0 {
                        quote! { (#base).resize::<U1>() }
                    } else {
                        quote! { (#base).xshr::<#ub>().resize::<U1>() }
                    };
                    return syn::parse2(expanded).unwrap();
                }
            }
        }

        expr
    }
}

#[proc_macro_attribute]
pub fn bitops(_attr: TokenStream, item: TokenStream) -> TokenStream {
    let func = parse_macro_input!(item as ItemFn);
    let mut folder = IndexExpander;
    let expanded = folder.fold_item_fn(func);
    quote!(#expanded).into()
}
