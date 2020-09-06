# Bauen
`sh build.sh`

# Vorbereiten
`docker network create ep3bs`

# Starten
`docker create --name ep3bs -v ep3bs-config:/var/www/html/config -p 8080:80 nilsramsperger/ep3-bs`
`docker network connect ep3bs ep3bs`