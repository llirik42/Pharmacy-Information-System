from dataclasses import dataclass


@dataclass
class DrugType:
    id: int
    name: str
    is_cookable: bool
