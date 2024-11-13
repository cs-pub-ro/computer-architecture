import random
import string
import re

def load_regex_from_file(file_path):
    try:
        with open(file_path, 'r') as file:
            regex = file.read().strip()
            return regex
    except FileNotFoundError:
        print(f"Error: The file '{file_path}' was not found.")
        return None

def generate_strings(regex, num_strings=100, error_rate=0.3):
    generated_strings = []
    
    for _ in range(num_strings):
        if random.random() > error_rate:
            generated_strings.append(generate_string_from_regex(regex))
        else:
            incorrect_string = generate_incorrect_string(regex)
            generated_strings.append(incorrect_string)
    
    return generated_strings

def generate_string_from_regex(regex):
    """
    În locul rstr.xeger(), generează un șir aleatoriu care respectă un pattern simplu de regex.
    Acesta va fi o implementare simplificată și va trebui să fie extinsă pentru regex-uri complexe.
    """
    if re.match(regex, '') is None:
        print("Regex invalid sau nu se poate genera șir.")
        return ""
    
    return generate_valid_string(regex)

def generate_valid_string(regex):
    """
    Funcție simplificată pentru a genera șiruri valide pe baza unui regex.
    Aici generăm șiruri simple în funcție de tipuri de regex comune.
    """
    # Exemple de regex-uri foarte simple
    if regex == r"\d{3}":
        return ''.join(random.choices(string.digits, k=3))
    elif regex == r"[a-z]{5,10}":
        length = random.randint(5, 10)
        return ''.join(random.choices(string.ascii_lowercase, k=length))
    elif regex == r"[A-Za-z0-9]{8}":
        return ''.join(random.choices(string.ascii_letters + string.digits, k=8))
    
    # Poți adăuga alte tipuri de regex-uri aici
    return ''.join(random.choices(string.ascii_letters + string.digits, k=10))

def generate_incorrect_string(regex):
    """
    Generează un șir incorect care seamănă cu unul valid, dar conține greșeli.
    """
    incorrect_string = random_string(5, 10)
    if random.random() > 0.5:
        correct_string = generate_valid_string(regex)
        incorrect_string = mutate_string(correct_string)
    return incorrect_string

def random_string(min_len, max_len):
    """
    Generează un șir aleatoriu de dimensiuni între min_len și max_len.
    """
    length = random.randint(min_len, max_len)
    return ''.join(random.choices(string.ascii_letters + string.digits, k=length))

def mutate_string(s):
    """
    Introduce greșeli aleatorii într-un șir, schimbând caracterele.
    """
    index = random.randint(0, len(s) - 1)
    mutated_char = random.choice("!@#$%^&*()_+-=")
    return s[:index] + mutated_char + s[index + 1:]

def save_strings_to_file(strings, file_path):
    """
    Salvează șirurile generate într-un fișier text.
    """
    try:
        with open(file_path, 'w') as file:
            for s in strings:
                file.write(s + '\n')
        print(f"Generated strings have been saved to '{file_path}'")
    except IOError:
        print(f"Error: Could not write to file '{file_path}'")

# Calea fișierului care conține regex-ul
regex_file_path = 'sequence.txt'
regex = load_regex_from_file(regex_file_path)

if regex:
    # Generează șirurile pe baza regex-ului și le salvează într-un fișier
    strings = generate_strings(regex, num_strings=100, error_rate=0.3)

    # Afișează șirurile generate în consolă
    for i, s in enumerate(strings):
        print(f"{i+1}: {s}")
    
    # Salvează șirurile într-un fișier
    save_strings_to_file(strings, 'test_inputs.txt')