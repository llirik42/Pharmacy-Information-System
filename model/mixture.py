from dataclasses import dataclass


@dataclass
class Mixture:
    drug_id: int
    solvent: str
    mixture_type_id: int
