from dataclasses import dataclass
from datetime import date


@dataclass
class Patient:
    id: int
    full_name: str
    birth_date: date
