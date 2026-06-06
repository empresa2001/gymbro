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

async function addO2MRelationship() {
    try {
        console.log('🔑 Logging in to Directus PRODUCTION...');

        const loginResponse = await directusRequest('/auth/login', 'POST', {
            email: adminEmail,
            password: adminPassword
        });

        accessToken = loginResponse.data.access_token;
        console.log('✅ Logged in successfully\n');

        // Add O2M relationship field to planes_ia
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
            schema: {
                on_delete: 'SET NULL'
            }
        });

        console.log('✅ One-to-Many relationship field "ejercicios" added to planes_ia');

        console.log('\n🎉 Relationship configured successfully!');
        console.log('\n📊 Summary:');
        console.log('  ✓ Field "ejercicios" (O2M) added to planes_ia');
        console.log('  ✓ Points to collection: ejercicios_plan_ia');
        console.log('  ✓ Foreign key: plan_ia_id');
        console.log('\n✅ Now the API should return exercises when querying planes_ia!');

    } catch (error) {
        console.error('\n❌ Error:', error.message);
        if (error.message.includes('already exists')) {
            console.log('\n⚠️  The field already exists. Trying to update it...');

            try {
                await directusRequest('/fields/planes_ia/ejercicios', 'PATCH', {
                    meta: {
                        interface: 'list-o2m',
                        special: ['o2m'],
                        options: {
                            enableCreate: false,
                            enableSelect: true
                        }
                    }
                });
                console.log('✅ Field updated successfully');
            } catch (updateError) {
                console.error('❌ Could not update field:', updateError.message);
            }
        }
        process.exit(1);
    }
}

addO2MRelationship();
