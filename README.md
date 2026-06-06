# 🏋️ GYM BRO - Sistema de Gestión de Gimnasio

MVP de sistema de gestión para gimnasios con seguimiento de clientes, planes de entrenamiento y progreso.

## 🚀 Stack Tecnológico

- **Backend/CMS:** Directus (API + Admin Panel)
- **Base de Datos:** PostgreSQL
- **Frontend:** React + Vite + Tailwind CSS
- **Contenerización:** Docker Compose
- **Despliegue Móvil:** PWA (Progressive Web App)

## 📋 Estructura del Proyecto

```
gym/
├── docker-compose.yml          # Configuración de servicios Docker
├── .env                        # Variables de entorno
├── directus-schema.json        # Schema de colecciones Directus
├── DIRECTUS_SETUP.md          # Guía de configuración Directus
└── frontend/                   # Aplicación React
    ├── public/
    ├── src/
    └── package.json
```

## 🐳 Inicio Rápido

### 1. Levantar el Backend (Directus + PostgreSQL)

```bash
# Iniciar servicios Docker
docker-compose up -d

# Verificar que los servicios estén corriendo
docker-compose ps

# Ver logs de Directus
docker-compose logs -f directus
```

**URLs:**
- Directus Admin: http://localhost:8055
- PostgreSQL: localhost:5432

**Credenciales por defecto:**
- Email: `admin@gymbro.com`
- Password: `Admin123!`

### 2. Configurar Directus

1. Accede a http://localhost:8055
2. Inicia sesión con las credenciales de admin
3. Sigue las instrucciones en `DIRECTUS_SETUP.md` para crear las colecciones y configurar permisos
4. O importa el schema automáticamente desde `directus-schema.json`

### 3. Iniciar el Frontend

```bash
cd frontend
npm install
npm run dev
```

La aplicación estará disponible en http://localhost:5173

## 👥 Roles de Usuario

### 🔑 Superadministrador
- Gestión de entrenadores (habilitar/deshabilitar)
- Panel de monitoreo con estadísticas
- CRUD de planes de entrenamiento

### 🏋️ Entrenador
- Gestión de clientes (crear, listar)
- Asignación de planes a clientes
- Seguimiento de progreso de clientes

### 🏃 Cliente/Deportista
- Registro de sesiones de entrenamiento
- Visualización de progreso con gráficos
- Estado de suscripción activa
- Contador de racha (streak)

## 🗃️ Estructura de Base de Datos

### Colecciones Principales

1. **directus_users** - Usuarios del sistema (con roles)
2. **entrenadores** - Información detallada de entrenadores
3. **clientes** - Información de clientes/deportistas
4. **planes** - Tipos de planes de entrenamiento
5. **suscripciones** - Asignación de planes a clientes
6. **sesiones_registro** - Registro de entrenamientos
7. **metricas_cliente** - Datos de progreso (opcional)

### Relaciones
- Cliente ↔ Entrenador (M2O)
- Suscripción ↔ Cliente (M2O)
- Suscripción ↔ Plan (M2O)
- Sesiones ↔ Cliente (M2O)
- Métricas ↔ Cliente (M2O)

## 📱 Configuración PWA

La aplicación está configurada como PWA y puede instalarse en dispositivos móviles:

1. Construir versión de producción:
   ```bash
   cd frontend
   npm run build
   npm run preview
   ```

2. Abrir en navegador móvil
3. Seleccionar "Instalar aplicación" o "Añadir a pantalla de inicio"

## 🚀 Despliegue

### Backend (Directus + PostgreSQL)
- **Desarrollo:** Docker Compose local
- **Producción:** VPS (DigitalOcean, Render, Railway) con PostgreSQL administrado

### Frontend
- **Desarrollo:** Vite dev server
- **Producción:** Vercel, Netlify, o cualquier hosting estático

### Variables de Entorno para Producción

1. Actualiza `PUBLIC_URL` en `.env` con tu dominio
2. Configura CORS en Directus para permitir tu frontend
3. Usa HTTPS para PWA (requerido)

## 🛠️ Comandos Útiles

```bash
# Ver logs de todos los servicios
docker-compose logs -f

# Reiniciar Directus
docker-compose restart directus

# Detener todos los servicios
docker-compose down

# Detener y eliminar volúmenes (CUIDADO: borra datos)
docker-compose down -v

# Frontend - Modo desarrollo
cd frontend && npm run dev

# Frontend - Build de producción
cd frontend && npm run build
```

## 📚 Documentación

- [Directus Docs](https://docs.directus.io/)
- [React Docs](https://react.dev/)
- [Tailwind CSS](https://tailwindcss.com/docs)
- [Vite](https://vitejs.dev/)

## 🤝 Soporte

Para cualquier problema:
1. Revisa los logs: `docker-compose logs -f`
2. Verifica que los servicios estén corriendo: `docker-compose ps`
3. Consulta `DIRECTUS_SETUP.md` para configuración de Directus

---

**Desarrollado para GYM BRO MVP** 💪
