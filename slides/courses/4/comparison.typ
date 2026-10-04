== Comparison Operations

- Less than (`lt`): $<$
- Less than or equal (`le`): $<= $
- Greater than (`gt`): $>$
- Greater than or equal (`ge`): $>= $
- Equal (`eq`): `==`
- Not equal (`ne`): $!= $

== Let's Do Some Math

Only `lt` and `eq` need to be implemented directly.

$
  "le" = "lt" or "eq" \
  "gt" = not "le" \
  "ge" = not "lt" \
  "ne" = not "eq"
$