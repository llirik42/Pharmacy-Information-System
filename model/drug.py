from dataclasses import dataclass


@dataclass
class Drug:
    id: int
    name: str
    cost: int
    shelf_life: int
    critical_amount: int
    type_id: int
    description: str
