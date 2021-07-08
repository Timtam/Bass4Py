"""
This package contains the main attribute types which can be found on i.e. 
:class:`Bass4Py.bass.ChannelBase`, :class:`Bass4Py.bass.Channel`, 
:class:`Bass4Py.bass.Music` and :class:`Bass4Py.bass.Stream` instances. You 
will most likely not interact with those classes directly, but use them when 
instanciated on one of those objects.

.. currentmodule:: Bass4Py.bass.attributes

The following attributes are available:

.. autosummary::
   :toctree:
   
   AttributeBase
   BoolAttribute
   BytesAttribute
   FloatAttribute
   FloatListAttribute

"""

from .attribute_base import AttributeBase
from .bool_attribute import BoolAttribute
from .bytes_attribute import BytesAttribute
from .float_attribute import FloatAttribute
from .float_list_attribute import FloatListAttribute
