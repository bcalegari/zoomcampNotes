import sys

import pandas as pd

print(sys.argv)
day = sys.argv[1]

# Pandas code testing
print(pd.__version__)
print(f'Job finished for day = {day}')