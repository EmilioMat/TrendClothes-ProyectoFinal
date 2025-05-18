<script setup>
import InputError from '@/Components/InputError.vue';
import InputLabel from '@/Components/InputLabel.vue';
import PrimaryButton from '@/Components/PrimaryButton.vue';
import TextInput from '@/Components/TextInput.vue';
import { Link, useForm, usePage } from '@inertiajs/vue3';
import { ref } from 'vue';

defineProps({
    mustVerifyEmail: Boolean,
    status: String,
});

const user = usePage().props.auth.user;
const avatarInput = ref(null);
const avatarPreview = ref(user.avatar_url);

const form = useForm({
    name: user.name,
    email: user.email,
    avatar: null,
});

const updateAvatar = () => {
    const avatarForm = useForm({ avatar: form.avatar });
    avatarForm.post(route('profile.avatar.update'), {
        preserveScroll: true,
        onSuccess: () => {
            avatarPreview.value = URL.createObjectURL(form.avatar);
            form.avatar = null;
        },
    });
};

const handleAvatarChange = (e) => {
    const file = e.target.files[0];
    if (file) {
        form.avatar = file;
        avatarPreview.value = URL.createObjectURL(file);
    }
};

const submit = () => {
    form.patch(route('profile.update'), { preserveScroll: true });
};
</script>

<template>
    <section class="space-y-6">
        <header class="mb-6">
            <h2 class="text-xl font-semibold text-gray-800 dark:text-gray-200">
                Información Personal
            </h2>
            <p class="text-sm text-gray-600 dark:text-gray-400">
                Actualiza tu nombre, email y avatar.
            </p>
        </header>

        <div class="mb-6 flex items-center gap-6">
            <img
                :src="avatarPreview"
                class="w-20 h-20 rounded-full object-cover border-2 border-gray-200 dark:border-gray-700"
                alt="Avatar"
            />
            <div>
                <input
                    type="file"
                    ref="avatarInput"
                    class="hidden"
                    accept="image/*"
                    @change="handleAvatarChange"
                />
                <button
                    type="button"
                    @click="avatarInput.click()"
                    class="text-sm text-gray-600 dark:text-gray-400 hover:text-gray-900 dark:hover:text-gray-200 underline"
                >
                    Cambiar avatar
                </button>
                <button
                    v-if="form.avatar"
                    @click="updateAvatar"
                    class="ml-4 px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition-colors dark:bg-blue-600 dark:hover:bg-blue-700"
                >
                    Guardar
                </button>
            </div>
        </div>

        <form @submit.prevent="submit" class="space-y-6">
            <div>
                <InputLabel for="name" value="Nombre" />
                <TextInput
                    id="name"
                    v-model="form.name"
                    type="text"
                    class="mt-1 block w-full border-gray-300 rounded-lg shadow-sm focus:border-blue-500 focus:ring-blue-500 dark:border-gray-600 dark:bg-gray-700 dark:text-gray-200"
                    required
                    autofocus
                    autocomplete="name"
                />
                <InputError :message="form.errors.name" class="mt-2" />
            </div>

            <div>
                <InputLabel for="email" value="Email" />
                <TextInput
                    id="email"
                    v-model="form.email"
                    type="email"
                    class="mt-1 block w-full border-gray-300 rounded-lg shadow-sm focus:border-blue-500 focus:ring-blue-500 dark:border-gray-600 dark:bg-gray-700 dark:text-gray-200"
                    required
                    autocomplete="username"
                />
                <InputError :message="form.errors.email" class="mt-2" />
            </div>

            <div v-if="mustVerifyEmail && !user.email_verified_at">
                <p class="text-sm text-gray-700 dark:text-gray-300">
                    Tu email no está verificado.
                    <Link
                        :href="route('verification.send')"
                        method="post"
                        as="button"
                        class="text-blue-600 hover:text-blue-800 dark:text-blue-400 dark:hover:text-blue-300 underline"
                    >
                        Reenviar verificación
                    </Link>
                </p>
                <p
                    v-show="status === 'verification-link-sent'"
                    class="mt-2 text-sm text-green-600 dark:text-green-400"
                >
                    Enlace de verificación enviado.
                </p>
            </div>

            <div class="flex items-center gap-4">
                <PrimaryButton :disabled="form.processing">
                    Guardar
                </PrimaryButton>
                <p
                    v-if="form.recentlySuccessful"
                    class="text-sm text-gray-600 dark:text-gray-400 transition-opacity duration-300"
                >
                    Guardado.
                </p>
            </div>
        </form>
    </section>
</template>