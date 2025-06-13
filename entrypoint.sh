echo "Esperando a que la base de datos esté lista..."
until mysql -h db -u root -proot -e "SHOW DATABASES;" > /dev/null 2>&1; do
  sleep 1
done

echo "Base de datos lista. Ejecutando migraciones..."
php artisan migrate --force

exec apache2-foreground
