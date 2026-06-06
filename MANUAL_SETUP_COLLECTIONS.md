# 🔧 Configuración Manual de Colecciones en Directus

Ya que la opción "Import Schema" no está disponible en la UI de Directus, vamos a crear las colecciones manualmente.

## Opción 1: Crear Colecciones desde la UI (RECOMENDADO PARA EMPEZAR)

### Paso 1: Crear Colección `planes`

1. Ve a **Settings → Data Model**
2. Click en **"Create Collection"**
3. Configura:
   - **Collection Name:** `planes`
   - **Type:** Standard Collection
   - Click **"Create"**

4. Agrega los siguientes campos (Click "+ Create Field"):

   **Campo 1: nombre** (String)
   - Interface: Input
   - Required: ✅ Yes
   
   **Campo 2: descripcion** (Text)
   - Interface: Textarea
   
   **Campo 3: duracion_dias** (Integer)
   - Interface: Input
   - Required: ✅ Yes
   
   **Campo 4: precio** (Decimal)
   - Interface: Input
   - Precision: 10, Scale: 2
   
   **Campo 5: activo** (Boolean)
   - Interface: Boolean
   - Default Value: true

5. Click **"Save"**

### Paso 2: Crear Colección `entrenadores`

1. Click **"Create Collection"**
2. Configura:
   - **Collection Name:** `entrenadores`
   - Click **"Create"**

3. Agrega campos:

   **Campo 1: user_id** (Many to One Relationship)
   - Related Collection: directus_users
   - Required: ✅ Yes
   
   **Campo 2: certificado** (String)
   - Interface: Input
   
   **Campo 3: especialidad** (String)
   - Interface: Input
   
   **Campo 4: telefono** (String)
   - Interface: Input

### Paso 3: Crear Colección `clientes`

1. Click **"Create Collection"**
2. Configura:
   - **Collection Name:** `clientes`
   - Click **"Create"**

3. Agrega campos:

   **Campo 1: user_id** (Many to One Relationship)
   - Related Collection: directus_users
   - Required: ✅ Yes
   
   **Campo 2: entrenador_asignado** (Many to One Relationship)
   - Related Collection: entrenadores
   
   **Campo 3: fecha_nacimiento** (Date)
   - Interface: Datetime
   
   **Campo 4: objetivo** (String)
   - Interface: Input
   
   **Campo 5: altura_cm** (Integer)
   - Interface: Input

### Paso 4: Crear Colección `suscripciones`

1. Click **"Create Collection"**
2. Configura:
   - **Collection Name:** `suscripciones`
   - Click **"Create"**

3. Agrega campos:

   **Campo 1: cliente_id** (Many to One Relationship)
   - Related Collection: clientes
   - Required: ✅ Yes
   
   **Campo 2: plan_id** (Many to One Relationship)
   - Related Collection: planes
   - Required: ✅ Yes
   
   **Campo 3: fecha_inicio** (Date)
   - Interface: Datetime
   - Required: ✅ Yes
   
   **Campo 4: fecha_fin** (Date)
   - Interface: Datetime
   
   **Campo 5: habilitado** (Boolean)
   - Interface: Boolean
   - Default Value: true

### Paso 5: Crear Colección `sesiones_registro`

1. Click **"Create Collection"**
2. Configura:
   - **Collection Name:** `sesiones_registro`
   - Click **"Create"**

3. Agrega campos:

   **Campo 1: cliente_id** (Many to One Relationship)
   - Related Collection: clientes
   - Required: ✅ Yes
   
   **Campo 2: fecha** (Date)
   - Interface: Datetime
   - Required: ✅ Yes
   
   **Campo 3: horas_entrenadas** (Decimal)
   - Interface: Input
   - Precision: 4, Scale: 2
   - Required: ✅ Yes
   
   **Campo 4: tipo_entrenamiento** (Dropdown)
   - Interface: Dropdown
   - Choices:
     - pesas → Pesas
     - cardio → Cardio
     - yoga → Yoga
     - funcional → Funcional
     - crossfit → Crossfit
     - natacion → Natación
     - mixto → Mixto
   
   **Campo 5: notas** (Text)
   - Interface: Textarea

### Paso 6: Crear Colección `metricas_cliente` (OPCIONAL)

1. Click **"Create Collection"**
2. Configura:
   - **Collection Name:** `metricas_cliente`
   - Click **"Create"**

3. Agrega campos:

   **Campo 1: cliente_id** (Many to One Relationship)
   - Related Collection: clientes
   - Required: ✅ Yes
   
   **Campo 2: fecha** (Date)
   - Interface: Datetime
   - Required: ✅ Yes
   
   **Campo 3: peso_kg** (Decimal)
   - Interface: Input
   - Precision: 5, Scale: 2
   
   **Campo 4: porcentaje_grasa** (Decimal)
   - Interface: Input
   - Precision: 4, Scale: 2
   
   **Campo 5: masa_muscular_kg** (Decimal)
   - Interface: Input
   - Precision: 5, Scale: 2
   
   **Campo 6: circunferencia_cintura_cm** (Integer)
   - Interface: Input

---

## Opción 2: Usar API/CLI de Directus (Más Rápido)

Si prefieres no crear manualmente, puedes usar el CLI de Directus desde Docker:

```bash
# Copiar el schema al contenedor
docker cp directus-schema.json gymbro_directus:/directus/

# Aplicar el schema
docker exec gymbro_directus npx directus schema apply /directus/directus-schema.json --yes
```

---

## ⚠️ Después de Crear las Colecciones

**IMPORTANTE:** Debes configurar los **Roles y Permisos** para que funcione correctamente:

1. Ve a **Settings → Access Control → Roles**
2. Crea dos nuevos roles:
   - **Entrenador**
   - **Cliente**

3. Configura permisos según `DIRECTUS_SETUP.md` (sección "Permisos por Rol")

---

¿Necesitas ayuda con algún paso específico?
