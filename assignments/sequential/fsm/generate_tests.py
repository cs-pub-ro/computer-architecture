import random
import sys
import string
import re

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
    if re.match(regex, '') is not None:
        print("Regex invalid sau nu se poate genera șir.")
        return ""
    
    return generate_valid_string(regex)

def generate_valid_string(regex):
    """
    Generate a valid string based on a limited subset of regex.
    """
    result = ""
    i = 0
    while i < len(regex):
        if regex[i] in "abc":
            letter=regex[i]
            if i + 1 < len(regex) and regex[i + 1] == '*':
                times = random.randint(0, 10)
                result += letter * times
                i += 1
            elif i + 1 < len(regex) and regex[i + 1] == '+':
                times = random.randint(1, 10)
                result += letter * times
                i += 1
            else:
                result += letter
        elif regex[i] == '(':
            end = regex.find(')', i)
            if end != -1:
                order = regex[i + 1:end]
                i = end
                if i + 1 < len(regex) and regex[i + 1] == '*':
                    times = random.randint(0, 5)
                    result += order * times
                    i += 1
                elif i + 1 < len(regex) and regex[i + 1] == '+':
                    times = random.randint(1, 5)
                    result += order * times
                    i += 1
                else:
                    result += order
            else:
                print("Regex invalid.")
                return ""
        else:
            print("Regex invalid.")
            return ""
        i += 1
        
    return ''.join(result)

def generate_incorrect_string(regex):
    """
    Generează un șir incorect care seamănă cu unul valid, dar conține greșeli.
    """
    correct_string = generate_valid_string(regex)
    length = len(correct_string)
    index = random.randint(0, length - 1)
    incorrect_string = correct_string[:index] + "d" + correct_string[index + 1:]
    return incorrect_string

def save_strings_to_file(strings, file_path):
    """
    Salvează șirurile generate într-un fișier text.
    """
    try:
        with open(file_path, 'w') as file:

            replacement_dict = {'a': '0', 'b': '1', 'c': '2', 'd': '3'}
            for s in strings:
                correct_string = re.fullmatch(regex, s) is not None
                new_string = ' '.join(map(lambda x: replacement_dict.get(x, '4'), s)) + ' 4 ' + ('1' if correct_string else '0')
                file.write(new_string + '\n')
        print(f"Generated strings have been saved to '{file_path}'")
    except IOError:
        print(f"Error: Could not write to file '{file_path}'")

# Calea fișierului care conține regex-ul

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print(f"Usage: {sys.argv[0]} <regex_file> <output_file>")
        sys.exit(1)
    regex_file = sys.argv[1].strip()
    output_file = sys.argv[2].strip()

    # Citirea regex-ului din fișier
    try:
        with open(regex_file, 'r') as file:
            regex = file.read().strip()
    except IOError:
        print(f"Error: Could not read file '{regex_file}'")


    # Set the seed for the random number generator
    random.seed(0)

    if regex:
        # Generează șirurile pe baza regex-ului și le salvează într-un fișier
        strings = generate_strings(regex, num_strings=100, error_rate=0.3)
        
        # Salvează șirurile într-un fișier
        save_strings_to_file(strings, output_file)