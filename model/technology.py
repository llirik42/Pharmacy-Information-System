from dataclasses import dataclass


@dataclass
class Technology:
    id: int
    drug_id: int
    cooking_time: int
    amount: int
    description: str
