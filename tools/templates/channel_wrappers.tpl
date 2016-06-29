# This file auto-generated by `generate_schema_interface.py`.
# Do not modify this file directly.

import traitlets as T
import pandas as pd

from ...utils import parse_shorthand, infer_vegalite_type

from .._interface import Type
{% for import_statement in objects|merge_imports -%}
  {{ import_statement }}
{% endfor %}

{% for object in objects -%}
class {{ object.name }}({{ object.base.name }}):
    """Wrapper for Vega-Lite {{ object.base.name }} definition.
    {{ object.base.description }}
    Attributes
    ----------
    shorthand: Unicode
        A shorthand description of the channel
    {% for attr in object.base.attributes -%}
    {{ attr.name }}: {% if attr.name == 'type' -%}
                          Union(Type, Unicode)
                     {%- else -%}
                          {{ attr.trait_descr}}
                     {%- endif %}
        {{ attr.short_description }}
    {% endfor -%}
    """
    # Traitlets
    shorthand = T.Unicode('')
    skip = ['shorthand']

    # Class Methods
    {%- set comma = joiner(", ") %}
    def __init__(self, shorthand='', {% for attr in object.base.attributes %}{{ attr.name }}=None, {% endfor %}**kwargs):
        kwargs['shorthand'] = shorthand
        kwds = dict({% for attr in object.base.attributes %}{{ comma() }}{{ attr.name }}={{ attr.name }}{% endfor %})
        kwargs.update({k:v for k, v in kwds.items() if v is not None})
        super({{ object.name }}, self).__init__(**kwargs)

    def _finalize(self, **kwargs):
        """Finalize object: this involves inferring types if necessary"""
        data = kwargs.get('data', None)

        # parse the shorthand to extract the field, type, and aggregate
        for key, val in parse_shorthand(self.shorthand).items():
            setattr(self, key, val)

        # infer the type if not already specified
        if not self.type:
            if isinstance(data, pd.DataFrame) and self.field in data:
                self.type = infer_vegalite_type(data[self.field])

        super({{ object.name }}, self)._finalize(**kwargs)


{% endfor %}
