from dataclasses import dataclass


@dataclass
class Pills:
    drug_id: int
    weight_of_pill: int
    pills_count: int
