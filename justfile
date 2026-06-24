[working-directory: 'rust']
pack-apple:
  boltffi pack apple -vv

[working-directory: 'apple']
tuist-generate:
  tuist generate

[working-directory: 'apple']
tuist-install:
  tuist install
