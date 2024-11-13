import re

def load_regex(file_path):
    try:
        with open(file_path, 'r') as file:
            regex = file.read().strip()
            return regex
    except FileNotFoundError:
        print(f"Error: The file {file_path} was not found.")
        return None
    except IOError:
        print(f"Error: Could not read file {file_path}.")
        return None

def check_input_against_regex(regex, user_input):
    return re.fullmatch(regex, user_input) is not None

def load_inputs(file_path):
    try:
        with open(file_path, 'r') as file:
            inputs = [line.strip() for line in file.readlines()]
            return inputs
    except FileNotFoundError:
        print(f"Error: The file {file_path} was not found.")
        return None
    except IOError:
        print(f"Error: Could not read file {file_path}.")
        return None
    
def main():
    regex_file = 'sequence.txt'    
    inputs_file = 'test_inputs.txt'
    output_file = 'results.txt'

    regex = load_regex(regex_file)
    if regex is None:
        return

    inputs = load_inputs(inputs_file)
    if inputs is None:
        return

    # Check each input from the file against the regex
    for user_input in inputs:
        check_input_against_regex(regex, user_input)

    # Open the output file to write results
    with open(output_file, 'w') as output:
        for user_input in inputs:
            match_result = check_input_against_regex(regex, user_input)
            result = f"1\n" if match_result else f"0\n"
            output.write(result)


if __name__ == "__main__":
    main()