from dataclasses import dataclass


@dataclass
class TechnologyComponent:
    technology_id: int
    component_id: int
    component_amount: int
