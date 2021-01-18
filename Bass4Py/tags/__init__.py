from Bass4Py.utils import prepare_imports

prepare_imports("tags")

from .tags import Tags

__all__ = (
  'Tags',
)