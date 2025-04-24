<script setup>
import { Head, useForm } from '@inertiajs/vue3';
import { ref } from 'vue';

const form = useForm({
    name: '',
    email: '',
    company: '',
    user_type: 'business',
    comments: '',
    is_developer: false,
});

const success = ref(false);

function submit() {
    form.post(route('waitlist.store'), {
        onSuccess: () => {
            form.reset();
            success.value = true;
            setTimeout(() => {
                success.value = false;
            }, 5000);
        },
    });
}
</script>

<template>
    <div>
        <Head>
            <title>Join the Waitlist | A2A Platform</title>
            <meta name="description" content="Join the waitlist for A2A Platform - the marketplace for outcome-based AI agents." />
        </Head>

        <div class="min-h-screen bg-white dark:bg-slate-900">
            <!-- Header -->
            <header class="sticky top-0 z-50 backdrop-blur bg-white/70 dark:bg-slate-900/70 border-b border-slate-200 dark:border-slate-800">
                <div class="max-w-7xl mx-auto flex items-center justify-between px-4 py-3">
                    <a href="/" class="text-xl font-bold text-fuchsia-600">A2A</a>
                    <nav class="hidden sm:flex gap-6 text-sm font-medium">
                        <a href="/#how" class="hover:text-fuchsia-600">How&nbsp;it&nbsp;works</a>
                        <a href="/#packs" class="hover:text-fuchsia-600">Packs</a>
                        <a href="/#devs" class="hover:text-fuchsia-600">Devs</a>
                    </nav>
                </div>
            </header>

            <!-- Form Section -->
            <div class="max-w-3xl mx-auto px-6 py-16">
                <h1 class="text-3xl font-bold text-center mb-8 text-slate-900 dark:text-white">Join the A2A Platform Waitlist</h1>
                
                <div v-if="success" class="mb-6 p-4 bg-green-100 border border-green-200 text-green-700 rounded-md">
                    Thank you for joining our waitlist! We will contact you soon.
                </div>

                <form @submit.prevent="submit" class="bg-white dark:bg-slate-800 rounded-lg shadow-md p-6 space-y-6">
                    <div>
                        <label for="name" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Name</label>
                        <input 
                            id="name" 
                            v-model="form.name" 
                            type="text" 
                            class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md shadow-sm focus:outline-none focus:ring-fuchsia-500 focus:border-fuchsia-500 dark:bg-slate-700 dark:text-white"
                            required
                        >
                        <div v-if="form.errors.name" class="text-red-500 text-sm mt-1">{{ form.errors.name }}</div>
                    </div>

                    <div>
                        <label for="email" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Email</label>
                        <input 
                            id="email" 
                            v-model="form.email" 
                            type="email" 
                            class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md shadow-sm focus:outline-none focus:ring-fuchsia-500 focus:border-fuchsia-500 dark:bg-slate-700 dark:text-white"
                            required
                        >
                        <div v-if="form.errors.email" class="text-red-500 text-sm mt-1">{{ form.errors.email }}</div>
                    </div>

                    <div>
                        <label for="company" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Company (optional)</label>
                        <input 
                            id="company" 
                            v-model="form.company" 
                            type="text" 
                            class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md shadow-sm focus:outline-none focus:ring-fuchsia-500 focus:border-fuchsia-500 dark:bg-slate-700 dark:text-white"
                        >
                        <div v-if="form.errors.company" class="text-red-500 text-sm mt-1">{{ form.errors.company }}</div>
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">I am a:</label>
                        <div class="space-y-2">
                            <div class="flex items-center">
                                <input 
                                    id="business" 
                                    v-model="form.user_type" 
                                    type="radio" 
                                    value="business" 
                                    class="h-4 w-4 text-fuchsia-600 focus:ring-fuchsia-500 border-gray-300"
                                >
                                <label for="business" class="ml-2 block text-sm text-gray-700 dark:text-gray-300">Business user</label>
                            </div>
                            <div class="flex items-center">
                                <input 
                                    id="developer" 
                                    v-model="form.user_type" 
                                    type="radio" 
                                    value="developer" 
                                    class="h-4 w-4 text-fuchsia-600 focus:ring-fuchsia-500 border-gray-300"
                                    @change="form.is_developer = form.user_type === 'developer'"
                                >
                                <label for="developer" class="ml-2 block text-sm text-gray-700 dark:text-gray-300">Developer</label>
                            </div>
                            <div class="flex items-center">
                                <input 
                                    id="other" 
                                    v-model="form.user_type" 
                                    type="radio" 
                                    value="other" 
                                    class="h-4 w-4 text-fuchsia-600 focus:ring-fuchsia-500 border-gray-300"
                                >
                                <label for="other" class="ml-2 block text-sm text-gray-700 dark:text-gray-300">Other</label>
                            </div>
                        </div>
                        <div v-if="form.errors.user_type" class="text-red-500 text-sm mt-1">{{ form.errors.user_type }}</div>
                    </div>

                    <div>
                        <label for="comments" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Comments (optional)</label>
                        <textarea 
                            id="comments" 
                            v-model="form.comments" 
                            rows="3" 
                            class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md shadow-sm focus:outline-none focus:ring-fuchsia-500 focus:border-fuchsia-500 dark:bg-slate-700 dark:text-white"
                        ></textarea>
                        <div v-if="form.errors.comments" class="text-red-500 text-sm mt-1">{{ form.errors.comments }}</div>
                    </div>

                    <div>
                        <button 
                            type="submit" 
                            class="w-full flex justify-center py-3 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-fuchsia-600 hover:bg-fuchsia-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-fuchsia-500"
                            :disabled="form.processing"
                        >
                            <span v-if="form.processing">Processing...</span>
                            <span v-else>Join Waitlist</span>
                        </button>
                    </div>
                </form>

                <div class="mt-8 text-center">
                    <a href="/" class="text-fuchsia-600 hover:text-fuchsia-700">← Back to home</a>
                </div>
            </div>
        </div>
    </div>
</template>
