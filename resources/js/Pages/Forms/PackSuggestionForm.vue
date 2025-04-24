<script setup>
import { Head, useForm } from '@inertiajs/vue3';
import { ref } from 'vue';

const form = useForm({
    name: '',
    email: '',
    pack_name: '',
    problem_it_solves: '',
    use_case: '',
    additional_details: '',
});

const success = ref(false);

function submit() {
    form.post(route('pack-suggestion.store'), {
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
            <title>Suggest a Pack | A2A Platform</title>
            <meta name="description" content="Suggest a new service pack for the A2A Platform - the marketplace for outcome-based AI agents." />
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
                <h1 class="text-3xl font-bold text-center mb-8 text-slate-900 dark:text-white">Suggest a Service Pack</h1>
                
                <div v-if="success" class="mb-6 p-4 bg-green-100 border border-green-200 text-green-700 rounded-md">
                    Thank you for your suggestion! We will review it soon.
                </div>

                <form @submit.prevent="submit" class="bg-white dark:bg-slate-800 rounded-lg shadow-md p-6 space-y-6">
                    <div>
                        <label for="name" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Your Name</label>
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
                        <label for="email" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Your Email</label>
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
                        <label for="pack_name" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Pack Name</label>
                        <input 
                            id="pack_name" 
                            v-model="form.pack_name" 
                            type="text" 
                            class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md shadow-sm focus:outline-none focus:ring-fuchsia-500 focus:border-fuchsia-500 dark:bg-slate-700 dark:text-white"
                            required
                        >
                        <div v-if="form.errors.pack_name" class="text-red-500 text-sm mt-1">{{ form.errors.pack_name }}</div>
                    </div>

                    <div>
                        <label for="problem_it_solves" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Problem it Solves</label>
                        <textarea 
                            id="problem_it_solves" 
                            v-model="form.problem_it_solves" 
                            rows="3" 
                            class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md shadow-sm focus:outline-none focus:ring-fuchsia-500 focus:border-fuchsia-500 dark:bg-slate-700 dark:text-white"
                            required
                        ></textarea>
                        <div v-if="form.errors.problem_it_solves" class="text-red-500 text-sm mt-1">{{ form.errors.problem_it_solves }}</div>
                    </div>

                    <div>
                        <label for="use_case" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Everyday Use Case</label>
                        <textarea 
                            id="use_case" 
                            v-model="form.use_case" 
                            rows="3" 
                            class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md shadow-sm focus:outline-none focus:ring-fuchsia-500 focus:border-fuchsia-500 dark:bg-slate-700 dark:text-white"
                            required
                        ></textarea>
                        <div v-if="form.errors.use_case" class="text-red-500 text-sm mt-1">{{ form.errors.use_case }}</div>
                    </div>

                    <div>
                        <label for="additional_details" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Additional Details (optional)</label>
                        <textarea 
                            id="additional_details" 
                            v-model="form.additional_details" 
                            rows="3" 
                            class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md shadow-sm focus:outline-none focus:ring-fuchsia-500 focus:border-fuchsia-500 dark:bg-slate-700 dark:text-white"
                        ></textarea>
                        <div v-if="form.errors.additional_details" class="text-red-500 text-sm mt-1">{{ form.errors.additional_details }}</div>
                    </div>

                    <div>
                        <button 
                            type="submit" 
                            class="w-full flex justify-center py-3 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-fuchsia-600 hover:bg-fuchsia-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-fuchsia-500"
                            :disabled="form.processing"
                        >
                            <span v-if="form.processing">Processing...</span>
                            <span v-else>Submit Suggestion</span>
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
