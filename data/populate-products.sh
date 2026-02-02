#!/bin/bash
# populate-products.sh
set -e

echo "Generating random product data..."

# Array of sample data components to mix and match
ADJECTIVES=("Pro" "Ultra" "Slim" "Gaming" "Wireless" "Vintage" "Smart" "Eco-friendly" "Premium" "Compact")
NOUNS=("Headphones" "Laptop" "Watch" "Desk" "Chair" "Monitor" "Keyboard" "Mouse" "Backpack" "Speaker")
CATEGORIES=("Electronics" "Office" "Furniture" "Accessories" "Gadgets")

generate_product() {
  adj=${ADJECTIVES[$RANDOM % ${#ADJECTIVES[@]}]}
  noun=${NOUNS[$RANDOM % ${#NOUNS[@]}]}
  name="$adj $noun $(($RANDOM % 1000))"
  
  desc="This is a fantastic $name suitable for all your needs. Features high quality materials."
  
  cat=${CATEGORIES[$RANDOM % ${#CATEGORIES[@]}]}
  
  # Price between 10 and 2000
  price=$(( ($RANDOM % 1990) + 10 )).99
  
  status="IN_STOCK"
  if [ $(($RANDOM % 10)) -gt 8 ]; then
    status="OUT_OF_STOCK"
  fi

  echo "INSERT INTO products (name, description, category, price, stock_status) VALUES ('$name', '$desc', '$cat', $price, '$status');"
}

# Generate 10 random products
SQL_STATEMENTS=""
for i in {1..10}; do
  SQL_STATEMENTS+="$(generate_product)"
done

# Execute in Postgres container
docker exec -i postgres psql -U postgres -d products_db <<EOF
$SQL_STATEMENTS
EOF

echo "Inserted 10 new products."
