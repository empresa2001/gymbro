import fetch from 'node-fetch';

// CONFIGURACIÓN PARA PRODUCCIÓN
const directusUrl = 'https://gym-bro-directus.onrender.com';
const adminEmail = 'admin@gymbro.com';
const adminPassword = 'GymBro2024!';

let accessToken = null;

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

async function fixO2MRelationship() {
    try {
        console.log('🔑 Logging in to Directus PRODUCTION...');

        const loginResponse = await directusRequest('/auth/login', 'POST', {
            email: adminEmail,
            password: adminPassword
        });

        accessToken = loginResponse.data.access_token;
        console.log('✅ Logged in successfully\n');

        // First, delete the field if it exists
        console.log('🗑️  Deleting existing "ejercicios" field if it exists...');
        try {
            await directusRequest('/fields/planes_ia/ejercicios', 'DELETE');
            console.log('  ✓ Deleted existing field');
        } catch (error) {
            console.log('  ⚠️  Field does not exist, continuing...');
        }

        console.log('\n⏳ Waiting 2 seconds...\n');
        await new Promise(resolve => setTimeout(resolve, 2000));

        // Add O2M relationship field with correct configuration
        console.log('📝 Adding One-to-Many relationship field to planes_ia...');

        await directusRequest('/fields/planes_ia', 'POST', {
            field: 'ejercicios',
            type: 'alias',
            meta: {
                interface: 'list-o2m',
                special: ['o2m'],
                options: {
                    enableCreate: false,
                    enableSelect: true
                },
                display: 'related-values',
                display_options: {
                    template: '{{ejercicio_id.nombre}}'
                }
            },
            schema: null
        });

        console.log('✅ Field "ejercicios" created');

        // Now update the field with relationship metadata
        console.log('\n📝 Configuring relationship metadata...');

        await directusRequest('/relations', 'POST', {
            collection: 'ejercicios_plan_ia',
            field: 'plan_ia_id',
            related_collection: 'planes_ia',
            meta: {
                many_collection: 'ejercicios_plan_ia',
                many_field: 'plan_ia_id',
                one_collection: 'planes_ia',
                one_field: 'ejercicios',
                one_collection_field: null,
                one_allowed_collections: null,
                junction_field: null,
                sort_field: 'orden',
                one_deselect_action: 'nullify'
            },
            schema: {
                on_delete: 'SET NULL'
            }
        });

        console.log('✅ Relationship metadata configured');

        console.log('\n🎉 O2M Relationship fully configured!');
        console.log('\n📊 Summary:');
        console.log('  ✓ Field "ejercicios" (O2M) added to planes_ia');
        console.log('  ✓ Relationship metadata set:');
        console.log('    - Many collection: ejercicios_plan_ia');
        console.log('    - Many field: plan_ia_id');
        console.log('    - One collection: planes_ia');
        console.log('    - One field: ejercicios');
        console.log('    - Sort by: orden');
        console.log('\n✅ Try querying planes_ia with ejercicios now!');

    } catch (error) {
        console.error('\n❌ Error:', error.message);
        process.exit(1);
    }
}

fixO2MRelationship();
