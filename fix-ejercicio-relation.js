import fetch from 'node-fetch';

const directusUrl = 'https://gym-bro-directus.onrender.com';
const adminEmail = 'admin@gymbro.com';
const adminPassword = 'GymBro2024!';

let accessToken = null;

async function directusRequest(endpoint, method = 'GET', body = null) {
    const headers = { 'Content-Type': 'application/json' };
    if (accessToken) headers['Authorization'] = `Bearer ${accessToken}`;

    const options = { method, headers };
    if (body) options.body = JSON.stringify(body);

    const response = await fetch(`${directusUrl}${endpoint}`, options);
    if (!response.ok) {
        const errorText = await response.text();
        throw new Error(`HTTP ${response.status}: ${errorText}`);
    }
    return response.json();
}

async function fixEjercicioRelation() {
    try {
        console.log('🔑 Logging in...');
        const loginResponse = await directusRequest('/auth/login', 'POST', {
            email: adminEmail,
            password: adminPassword
        });
        accessToken = loginResponse.data.access_token;
        console.log('✅ Logged in\n');

        // Update ejercicio_id field to have M2O interface
        console.log('📝 Updating ejercicio_id field interface...');
        await directusRequest('/fields/ejercicios_plan_ia/ejercicio_id', 'PATCH', {
            meta: {
                interface: 'select-dropdown-m2o',
                special: ['m2o'],
                options: {
                    template: '{{nombre}}'
                },
                display: 'related-values',
                display_options: {
                    template: '{{nombre}}'
                }
            }
        });
        console.log('✅ Field interface updated\n');

        // Verify/create relation metadata
        console.log('📝 Configuring relation metadata...');
        try {
            await directusRequest('/relations', 'POST', {
                collection: 'ejercicios_plan_ia',
                field: 'ejercicio_id',
                related_collection: 'ejercicios',
                meta: {
                    many_collection: 'ejercicios_plan_ia',
                    many_field: 'ejercicio_id',
                    one_collection: 'ejercicios',
                    one_deselect_action: 'nullify'
                },
                schema: {
                    on_delete: 'SET NULL'
                }
            });
            console.log('✅ Relation metadata created');
        } catch (error) {
            if (error.message.includes('already exists')) {
                console.log('⚠️  Relation already exists, updating...');
                // Relation exists, that's fine
            } else {
                throw error;
            }
        }

        console.log('\n🎉 ejercicio_id relation configured!');
        console.log('✅ Try querying planes_ia again - ejercicio_id data should now appear');

    } catch (error) {
        console.error('\n❌ Error:', error.message);
        process.exit(1);
    }
}

fixEjercicioRelation();
