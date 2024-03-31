from typing import Optional
from dataclasses import dataclass
from datetime import datetime


@dataclass
class Supply:
    id: int
    drug_id: int
    drug_amount: int
    cost: int
    assigned_date: datetime
    delivered_date: Optional[datetime]
    supplier_id: int
