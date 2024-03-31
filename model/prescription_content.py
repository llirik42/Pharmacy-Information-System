from dataclasses import dataclass


@dataclass
class PrescriptionContent:
    prescription_id: int
    drug_id: int
    amount: int
    administration_route_id: int
