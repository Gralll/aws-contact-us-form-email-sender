import pytest
import re


def test_regex():
    response = "Message with ID: 2342343-23423 was sent successfully"
    template = re.compile('Message with ID: .* was sent successfully')
    if template.search(response): 
        print('CONTAINS')
    else:
        print("NOT")

    assert template.search(response)