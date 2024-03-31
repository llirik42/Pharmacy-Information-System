from dataclasses import dataclass


@dataclass
class Customer:
    id: int
    full_name: str
    phone_number: str
    address: str
