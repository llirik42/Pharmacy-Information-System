from dataclasses import dataclass
from datetime import datetime


@dataclass
class StorageItem:
    id: int
    drug_id: int
    available_amount: int
    original_amount: int
    receipt_date: datetime
