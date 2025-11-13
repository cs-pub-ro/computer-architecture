#!/usr/bin/env python3
"""
Exercise: Moore Finite State Machine (FSM)
Given a Moore FSM state transition diagram, determine the output sequence
for a given input sequence.

In a Moore FSM:
- Output depends ONLY on the current state (not on input)
- States are labeled as: state_name/output

Compatible with Moodle CodeRunner plugin.
"""

import sys
import json
import random
# import datetime

# Parse arguments from Moodle CodeRunner
args = {param.split('=')[0]: param.split('=')[1] for param in sys.argv[1:]}
student_id = args.get('id', '0')

# Change this for each exam period
exam_secret = 12345
# Seed with current hour to vary questions throughout the day
# just for simulation purposes
# hour=datetime.datetime.now().hour
# random.seed(exam_secret + int(student_id) + hour)
random.seed(exam_secret + int(student_id))

# ============================================================================
# Moore FSM Generator
# ============================================================================


class MooreFSM:
    """Generates and manages Moore FSM instances"""
    
    def __init__(self, num_states=5, input_alphabet=None, output_alphabet=None):
        """
        Initialize Moore FSM
        
        Args:
            num_states: Number of states (4-7)
            input_alphabet: List of possible input symbols
            output_alphabet: List of possible output symbols
        """
        self.num_states = num_states
        self.input_alphabet = input_alphabet or ['0', '1']
        self.output_alphabet = output_alphabet or ['A', 'B']
        self.initial_state = 0
        
        # Generate random state outputs
        self.state_outputs = {i: random.choice(self.output_alphabet) 
                             for i in range(num_states)}
        
        # Generate transition table: transitions[state][input] = next_state
        self.transitions = {}
        for state in range(num_states):
            self.transitions[state] = {}
            for inp in self.input_alphabet:
                self.transitions[state][inp] = random.randint(0, num_states - 1)
    
    def process_input_sequence(self, input_sequence):
        """
        Process input sequence and return output sequence
        
        Args:
            input_sequence: String of input symbols
            
        Returns:
            Tuple of (output_sequence, state_trace)
        """
        current_state = self.initial_state
        output_sequence = ""
        state_trace = [current_state]
        
        for inp in input_sequence:
            # Output is determined by current state (Moore machine)
            output = self.state_outputs[current_state]
            output_sequence += output
            
            # Transition to next state
            current_state = self.transitions[current_state][inp]
            state_trace.append(current_state)
        output_sequence += self.state_outputs[current_state]
        
        return output_sequence, state_trace
    
    def get_state_diagram_html(self):
        """Generate HTML representation of FSM state diagram"""
        html = """
        <div class="fsm-diagram">
            <h4>Moore FSM State Diagram</h4>
            <table border="1" style="border-collapse: collapse; margin: 10px 0;">
                <tr style="background-color: #f0f0f0;">
                    <th style="padding: 8px;">Current State</th>
                    <th style="padding: 8px;">Output</th>
        """
        
        for inp in self.input_alphabet:
            html += f'<th style="padding: 8px;">Input: {inp}</th>'
        
        html += """
                </tr>
        """
        
        for state in range(self.num_states):
            html += f'<tr><td style="padding: 8px;">S{state}</td>'
            html += f'<td style="padding: 8px; text-align: center; background-color: #fff0f0;"><strong>{self.state_outputs[state]}</strong></td>'
            
            for inp in self.input_alphabet:
                next_state = self.transitions[state][inp]
                html += f'<td style="padding: 8px; text-align: center;">S{next_state}</td>'
            
            html += '</tr>'
        
        html += """
            </table>
            <p><em><strong>Initial State:</strong> S0</em></p>
        </div>
        """
        
        return html


# ============================================================================
# FSM Types (just random for now)
# ============================================================================

def create_random_fsm():
    """Creates a random Moore FSM"""
    num_states = random.choice([5, 6, 7])
    input_alphabet = ['0', '1', '2']  # Up to 3 input symbols
    output_alphabet = ['A', 'B', 'C', 'D']  # Up to 4 output symbols
    return MooreFSM(num_states=num_states,
                    input_alphabet=input_alphabet,
                    output_alphabet=output_alphabet)


# ============================================================================
# Generate FSM and Query
# ============================================================================

# Choose FSM type
fsm = create_random_fsm()
fsm_description = "Random Moore FSM"

# Generate input sequence (4-6 symbols for reasonable complexity)
sequence_length = random.randint(4, 6)
input_sequence = ''.join(random.choice(fsm.input_alphabet) for _ in range(sequence_length))

# Process the input sequence
output_sequence, state_trace = fsm.process_input_sequence(input_sequence)

# ============================================================================
# Generate HTML Question
# ============================================================================

html_question = f"""
<div class="fsm-question">
    <h3>Moore Finite State Machine (FSM) Analysis</h3>

    <p><strong>FSM Diagram:</strong></p>

    {fsm.get_state_diagram_html()}
    
    <h4>Question:</h4>
    <p>Given the input sequence: <code style="background-color: #f0f0f0; padding: 2px 4px;">{input_sequence}</code></p>
    <p>Trace through the FSM starting from the initial state (S0) and determine the output sequence.</p>
    
    <h4>Answer Format:</h4>
    <p>Enter the complete output sequence as a string (e.g., <code>AB</code> or <code>ACAB</code>)</p>
"""

html_question += """
</div>
"""

# ============================================================================
# Generate JSON Output
# ============================================================================

output = {
    'question': html_question,
    'result': output_sequence,
    # 'input_sequence': input_sequence,
    # 'output_sequence': output_sequence,
    # 'state_trace': state_trace,
    # 'num_states': fsm.num_states,
    # 'state_outputs': {f'q{k}': v for k, v in fsm.state_outputs.items()},
    # 'transitions': {f'q{k}': {inp: f'q{v}' for inp, v in fsm.transitions[k].items()} 
    #                for k in fsm.transitions.keys()}
}

print(json.dumps(output))

# ============================================================================
# For testing: write HTML to file
# ============================================================================
with open('html_question.html', 'w') as f:
    f.write(html_question)
