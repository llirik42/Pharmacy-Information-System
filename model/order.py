from typing import Optional
from dataclasses import dataclass
from datetime import datetime


@dataclass
class Order:
    id: int
    prescription_id: int
    registration_date: datetime
    appointed_date: Optional[datetime]
    obtaining_date: Optional[datetime]
    is_paid: bool
    customer_id: int
