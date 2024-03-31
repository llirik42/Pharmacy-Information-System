from dataclasses import dataclass


@dataclass
class ReservedDrug:
    order_id: int
    storage_item_id: int
    drug_amount: int
