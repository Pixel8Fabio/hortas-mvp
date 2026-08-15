# Hortas Comunitárias — Rails MVP

Base de código para um MVP em Ruby on Rails + Hotwire + PostgreSQL/PostGIS.

## Escopo deste MVP

- autenticação com Devise;
- cadastro e aprovação de hortas;
- fotos com Active Storage;
- coordenadas em PostGIS;
- lista e detalhe das hortas;
- mapa com OpenStreetMap/Leaflet;
- navegação compatível com Hotwire/Hotwire Native.

## Setup

```bash
bin/setup
bin/rails db:create
bin/rails db:migrate
bin/rails server
```
