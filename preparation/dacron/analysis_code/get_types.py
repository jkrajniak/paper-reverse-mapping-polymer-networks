import sys

h5filename = sys.argv[1]

import _get_types
_get_types.get_types(h5filename)
