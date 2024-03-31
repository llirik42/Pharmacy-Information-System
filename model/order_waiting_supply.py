from dataclasses import dataclass


@dataclass
class OrderWaitingSupply:
    order_id: int
    drug_id: int
    amount: int
