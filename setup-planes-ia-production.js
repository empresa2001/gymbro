import fetch from 'node-fetch';

// CONFIGURACIÓN PARA PRODUCCIÓN
const directusUrl = 'https://gym-bro-directus.onrender.com';
const adminEmail = 'admin@gymbro.com';
const adminPassword = 'GymBro2024!';

let accessToken = null;

// Helper function to make authenticated requests
async function directusRequest(endpoint, method = 'GET', body = null) {
    const headers = {
        'Content-Type': 'application/json'
    };

    if (accessToken) {
        headers['Authorization'] = `Bearer ${accessToken}`;
    }

    const options = {
        method,
        headers
    };

    if (body) {
        options.body = JSON.stringify(body);
    }

    const response = await fetch(`${directusUrl}${endpoint}`, options);

    if (!response.ok) {
        const errorText = await response.text();
        throw new Error(`HTTP ${response.status}: ${errorText}`);
    }

    return response.json();
}

async function setupPlanesIASchema() {
    try {
        console.log('🔑 Logging in to Directus PRODUCTION...');
        console.log('URL:', directusUrl);

        // Login using REST API
        const loginResponse = await directusRequest('/auth/login', 'POST', {
            email: adminEmail,
            password: adminPassword
        });

        accessToken = loginResponse.data.access_token;
        console.log('✅ Logged in successfully\n');

        // ========================================
        // 1. Create planes_ia collection
        // ========================================
        console.log('📦 Creating collection: planes_ia...');

        try {
            await directusRequest('/collections', 'POST', {
                collection: 'planes_ia',
                meta: {
                    icon: 'psychology',
                    note: 'Planes de entrenamiento generados por IA',
                    display_template: '{{nombre}}',
                    archive_field: 'activo',
                    archive_value: 'false',
                    unarchive_value: 'true'
                },
                schema: {
                    name: 'planes_ia'
                }
            });
            console.log('✅ Collection planes_ia created');
        } catch (error) {
            if (error.message.includes('already exists')) {
                console.log('⚠️  Collection planes_ia already exists, skipping...');
            } else {
                throw error;
            }
        }

        // Add fields to planes_ia
        console.log('\n📝 Adding fields to planes_ia...');

        const planesIAFields = [
            {
                field: 'id',
                type: 'uuid',
                schema: { is_primary_key: true },
                meta: { hidden: true, readonly: true, interface: 'input', special: ['uuid'] }
            },
            {
                field: 'cliente_id',
                type: 'integer',
                schema: { foreign_key_table: 'clientes', foreign_key_column: 'id' },
                meta: { interface: 'select-dropdown-m2o', special: ['m2o'], required: true }
            },
            {
                field: 'nombre',
                type: 'string',
                schema: { max_length: 255 },
                meta: { interface: 'input', required: true }
            },
            {
                field: 'descripcion',
                type: 'text',
                meta: { interface: 'input-multiline' }
            },
            {
                field: 'objetivo',
                type: 'string',
                schema: { max_length: 100 },
                meta: {
                    interface: 'select-dropdown',
                    options: {
                        choices: [
                            { text: 'Perder Peso', value: 'perder_peso' },
                            { text: 'Ganar Músculo', value: 'ganar_musculo' },
                            { text: 'Tonificar', value: 'tonificar' },
                            { text: 'Resistencia', value: 'resistencia' },
                            { text: 'Fuerza', value: 'fuerza' },
                            { text: 'Flexibilidad', value: 'flexibilidad' }
                        ]
                    }
                }
            },
            {
                field: 'nivel_experiencia',
                type: 'string',
                schema: { max_length: 50 },
                meta: {
                    interface: 'select-dropdown',
                    options: {
                        choices: [
                            { text: 'Principiante', value: 'principiante' },
                            { text: 'Intermedio', value: 'intermedio' },
                            { text: 'Avanzado', value: 'avanzado' }
                        ]
                    }
                }
            },
            {
                field: 'duracion_tipo',
                type: 'string',
                schema: { max_length: 50 },
                meta: {
                    interface: 'select-dropdown',
                    options: {
                        choices: [
                            { text: 'Diario', value: 'diario' },
                            { text: 'Semanal', value: 'semanal' },
                            { text: 'Mensual', value: 'mensual' }
                        ]
                    }
                }
            },
            {
                field: 'dias_semana',
                type: 'integer',
                meta: { interface: 'input', note: 'Cantidad de días por semana' }
            },
            {
                field: 'equipamiento',
                type: 'json',
                meta: { interface: 'tags', note: 'Equipamiento disponible' }
            },
            {
                field: 'limitaciones',
                type: 'text',
                meta: { interface: 'input-multiline', note: 'Lesiones o restricciones' }
            },
            {
                field: 'fecha_generacion',
                type: 'timestamp',
                meta: { interface: 'datetime', readonly: true, special: ['date-created'] }
            },
            {
                field: 'prompt_usado',
                type: 'text',
                meta: { interface: 'input-multiline', readonly: true }
            },
            {
                field: 'activo',
                type: 'boolean',
                schema: { default_value: true },
                meta: { interface: 'boolean', special: ['cast-boolean'] }
            },
            {
                field: 'date_created',
                type: 'timestamp',
                meta: { interface: 'datetime', readonly: true, hidden: true, special: ['date-created'] }
            },
            {
                field: 'date_updated',
                type: 'timestamp',
                meta: { interface: 'datetime', readonly: true, hidden: true, special: ['date-updated'] }
            }
        ];

        for (const fieldDef of planesIAFields) {
            try {
                await directusRequest(`/fields/planes_ia`, 'POST', fieldDef);
                console.log(`  ✓ Field "${fieldDef.field}" created`);
            } catch (error) {
                if (error.message.includes('already exists')) {
                    console.log(`  ⚠️  Field "${fieldDef.field}" already exists, skipping...`);
                } else {
                    console.error(`  ❌ Error creating field "${fieldDef.field}":`, error.message);
                }
            }
        }

        // ========================================
        // 2. Create ejercicios_plan_ia collection
        // ========================================
        console.log('\n📦 Creating collection: ejercicios_plan_ia...');

        try {
            await directusRequest('/collections', 'POST', {
                collection: 'ejercicios_plan_ia',
                meta: {
                    icon: 'fitness_center',
                    note: 'Junction table: Ejercicios de planes IA'
                },
                schema: {
                    name: 'ejercicios_plan_ia'
                }
            });
            console.log('✅ Collection ejercicios_plan_ia created');
        } catch (error) {
            if (error.message.includes('already exists')) {
                console.log('⚠️  Collection ejercicios_plan_ia already exists, skipping...');
            } else {
                throw error;
            }
        }

        // Add fields to ejercicios_plan_ia
        console.log('\n📝 Adding fields to ejercicios_plan_ia...');

        const ejerciciosPlanIAFields = [
            {
                field: 'id',
                type: 'integer',
                schema: { is_primary_key: true, has_auto_increment: true },
                meta: { hidden: true, readonly: true }
            },
            {
                field: 'plan_ia_id',
                type: 'uuid',
                schema: { foreign_key_table: 'planes_ia', foreign_key_column: 'id' },
                meta: { interface: 'select-dropdown-m2o', special: ['m2o'], required: true }
            },
            {
                field: 'ejercicio_id',
                type: 'uuid',
                schema: { foreign_key_table: 'ejercicios', foreign_key_column: 'id' },
                meta: { interface: 'select-dropdown-m2o', special: ['m2o'], required: true }
            },
            {
                field: 'dia',
                type: 'integer',
                meta: { interface: 'input', note: 'Día del plan (1-7 semanal, 1-30 mensual)' }
            },
            {
                field: 'orden',
                type: 'integer',
                meta: { interface: 'input', required: true }
            },
            {
                field: 'series',
                type: 'integer',
                meta: { interface: 'input' }
            },
            {
                field: 'repeticiones',
                type: 'string',
                schema: { max_length: 50 },
                meta: { interface: 'input', note: 'Ej: "12-15" o "30 segundos"' }
            },
            {
                field: 'duracion_minutos',
                type: 'integer',
                meta: { interface: 'input' }
            },
            {
                field: 'notas',
                type: 'text',
                meta: { interface: 'input-multiline' }
            },
            {
                field: 'date_created',
                type: 'timestamp',
                meta: { interface: 'datetime', readonly: true, hidden: true, special: ['date-created'] }
            }
        ];

        for (const fieldDef of ejerciciosPlanIAFields) {
            try {
                await directusRequest(`/fields/ejercicios_plan_ia`, 'POST', fieldDef);
                console.log(`  ✓ Field "${fieldDef.field}" created`);
            } catch (error) {
                if (error.message.includes('already exists')) {
                    console.log(`  ⚠️  Field "${fieldDef.field}" already exists, skipping...`);
                } else {
                    console.error(`  ❌ Error creating field "${fieldDef.field}":`, error.message);
                }
            }
        }

        // ========================================
        // 3. Add field to clientes
        // ========================================
        console.log('\n📝 Adding field tipo_plan_preferido to clientes...');

        try {
            await directusRequest(`/fields/clientes`, 'POST', {
                field: 'tipo_plan_preferido',
                type: 'string',
                schema: { max_length: 50 },
                meta: {
                    interface: 'select-dropdown',
                    options: {
                        choices: [
                            { text: 'Plan con Profesor', value: 'profesor' },
                            { text: 'Plan Generado por IA', value: 'ia' },
                            { text: 'Ambos', value: 'ambos' }
                        ]
                    },
                    note: 'Preferencia del cliente para tipo de plan'
                }
            });
            console.log('✅ Field tipo_plan_preferido added to clientes');
        } catch (error) {
            if (error.message.includes('already exists')) {
                console.log('⚠️  Field tipo_plan_preferido already exists in clientes, skipping...');
            } else {
                console.error('❌ Error:', error.message);
            }
        }

        console.log('\n🎉 Schema setup completed successfully in PRODUCTION!');
        console.log('\n📊 Summary:');
        console.log('  ✓ Collection planes_ia created/verified');
        console.log('  ✓ Collection ejercicios_plan_ia created/verified');
        console.log('  ✓ Field tipo_plan_preferido added to clientes');
        console.log('\n⚠️  Next steps:');
        console.log('  1. Configure permissions for Cliente role in Directus Admin');
        console.log('  2. Visit https://gym-bro-directus.onrender.com to verify collections');

    } catch (error) {
        console.error('\n❌ Error setting up schema:', error.message);
        if (error.stack) {
            console.error(error.stack);
        }
        process.exit(1);
    }
}

// Run the setup
setupPlanesIASchema();
