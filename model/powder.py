from dataclasses import dataclass


@dataclass
class Powder:
    drug_id: int
    is_composite: bool
