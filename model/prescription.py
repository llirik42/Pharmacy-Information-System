from dataclasses import dataclass
from datetime import datetime


@dataclass
class Prescription:
    id: int
    diagnosis: str
    patient_id: int
    doctor_id: int
    date: datetime
