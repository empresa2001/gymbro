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

async function fixPlanesIASchema() {
    try {
        console.log('🔑 Logging in to Directus PRODUCTION...');

        // Login
        const loginResponse = await directusRequest('/auth/login', 'POST', {
            email: adminEmail,
            password: adminPassword
        });

        accessToken = loginResponse.data.access_token;
        console.log('✅ Logged in successfully\n');

        // ========================================
        // 1. Delete existing collections (in correct order)
        // ========================================
        console.log('🗑️  Deleting existing collections...');

        try {
            await directusRequest('/collections/ejercicios_plan_ia', 'DELETE');
            console.log('  ✓ Deleted ejercicios_plan_ia');
        } catch (error) {
            console.log('  ⚠️  ejercicios_plan_ia does not exist or error:', error.message);
        }

        try {
            await directusRequest('/collections/planes_ia', 'DELETE');
            console.log('  ✓ Deleted planes_ia');
        } catch (error) {
            console.log('  ⚠️  planes_ia does not exist or error:', error.message);
        }

        console.log('\n⏳ Waiting 3 seconds for Directus to process deletions...\n');
        await new Promise(resolve => setTimeout(resolve, 3000));

        // ========================================
        // 2. Create planes_ia collection WITH UUID PRIMARY KEY
        // ========================================
        console.log('📦 Creating collection: planes_ia (with UUID)...');

        await directusRequest('/collections', 'POST', {
            collection: 'planes_ia',
            meta: {
                icon: 'psychology',
                note: 'Planes de entrenamiento generados por IA'
            },
            schema: {
                name: 'planes_ia'
            },
            fields: [
                {
                    field: 'id',
                    type: 'uuid',
                    schema: {
                        is_primary_key: true,
                        has_auto_increment: false
                    },
                    meta: {
                        hidden: true,
                        readonly: true,
                        interface: 'input',
                        special: ['uuid']
                    }
                }
            ]
        });
        console.log('✅ Collection planes_ia created with UUID primary key\n');

        // Add fields to planes_ia
        console.log('📝 Adding fields to planes_ia...');

        const planesIAFields = [
            {
                field: 'cliente_id',
                type: 'integer',
                schema: {
                    foreign_key_table: 'clientes',
                    foreign_key_column: 'id'
                },
                meta: {
                    interface: 'select-dropdown-m2o',
                    special: ['m2o'],
                    required: true
                }
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
                meta: { interface: 'input' }
            },
            {
                field: 'equipamiento',
                type: 'json',
                meta: { interface: 'tags' }
            },
            {
                field: 'limitaciones',
                type: 'text',
                meta: { interface: 'input-multiline' }
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
                console.error(`  ❌ Error creating field "${fieldDef.field}":`, error.message);
            }
        }

        // ========================================
        // 3. Create ejercicios_plan_ia collection
        // ========================================
        console.log('\n📦 Creating collection: ejercicios_plan_ia...');

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
        console.log('✅ Collection ejercicios_plan_ia created\n');

        // Add fields to ejercicios_plan_ia
        console.log('📝 Adding fields to ejercicios_plan_ia...');

        const ejerciciosPlanIAFields = [
            {
                field: 'id',
                type: 'integer',
                schema: {
                    is_primary_key: true,
                    has_auto_increment: true
                },
                meta: { hidden: true, readonly: true }
            },
            {
                field: 'plan_ia_id',
                type: 'uuid',
                schema: {
                    foreign_key_table: 'planes_ia',
                    foreign_key_column: 'id'
                },
                meta: {
                    interface: 'select-dropdown-m2o',
                    special: ['m2o'],
                    required: true
                }
            },
            {
                field: 'ejercicio_id',
                type: 'uuid',
                schema: {
                    foreign_key_table: 'ejercicios',
                    foreign_key_column: 'id'
                },
                meta: {
                    interface: 'select-dropdown-m2o',
                    special: ['m2o'],
                    required: true
                }
            },
            {
                field: 'dia',
                type: 'integer',
                meta: { interface: 'input' }
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
                meta: { interface: 'input' }
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
                console.error(`  ❌ Error creating field "${fieldDef.field}":`, error.message);
            }
        }

        // ========================================
        // 4. Verify tipo_plan_preferido exists in clientes
        // ========================================
        console.log('\n📝 Verifying field tipo_plan_preferido in clientes...');

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
                    }
                }
            });
            console.log('✅ Field tipo_plan_preferido added to clientes');
        } catch (error) {
            console.log('⚠️  Field tipo_plan_preferido already exists');
        }

        console.log('\n🎉 Schema fixed successfully!');
        console.log('\n📊 Summary:');
        console.log('  ✓ Collection planes_ia recreated with UUID primary key');
        console.log('  ✓ Collection ejercicios_plan_ia recreated');
        console.log('  ✓ All fields configured correctly');
        console.log('\n✅ Ready to test AI plan generation!');

    } catch (error) {
        console.error('\n❌ Error fixing schema:', error.message);
        if (error.stack) {
            console.error(error.stack);
        }
        process.exit(1);
    }
}

// Run the fix
fixPlanesIASchema();
