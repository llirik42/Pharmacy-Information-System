from typing import Optional
from dataclasses import dataclass
from datetime import datetime


@dataclass
class Production:
    order_id: int
    technology_id: int
    amount: int
    start_date: Optional[datetime]
    end_date: Optional[datetime]
