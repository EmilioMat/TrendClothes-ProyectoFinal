<template>
    <div
        class="bg-white p-6 rounded-xl shadow-lg border border-gray-200 overflow-auto"
    >
        <!--Encabezado con resumen-->
        <div class="flex justify-between items-center mb-6">
            <h3
                class="text-xl font-bold text-gray-900 bg-gradient-to-r from-blue-600 to-indigo-600 bg-clip-text text-transparent"
            >
                Informes de Venta
            </h3>
            <div class="text-sm text-gray-600">
                Actualizado:
                {{
                    new Date().toLocaleString("es-ES", {
                        dateStyle: "full",
                        timeStyle: "short",
                    })
                }}
            </div>
        </div>

        <!-- Estado de carga o sin datos -->
        <div v-if="!orders" class="text-center py-10 text-gray-500">
            <svg
                class="animate-spin h-8 w-8 mx-auto mb-2 text-blue-600"
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
            >
                <circle
                    class="opacity-25"
                    cx="12"
                    cy="12"
                    r="10"
                    stroke="currentColor"
                    stroke-width="4"
                ></circle>
                <path
                    class="opacity-75"
                    fill="currentColor"
                    d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"
                ></path>
            </svg>
            Cargando datos...
        </div>
        <div
            v-else-if="orders.length === 0"
            class="text-center py-10 text-gray-500"
        >
            No hay datos de ventas disponibles.
        </div>

        <!-- Tabla de informe de ventas -->
        <div v-else class="overflow-x-auto">
            <table
                class="min-w-full divide-y divide-gray-200 border rounded-lg"
            >
                <thead class="bg-gradient-to-r from-blue-100 to-indigo-100">
                    <tr>
                        <th
                            class="px-6 py-3 text-left text-sm font-semibold text-gray-700 uppercase tracking-wider"
                        >
                            ID
                        </th>
                        <th
                            class="px-6 py-3 text-left text-sm font-semibold text-gray-700 uppercase tracking-wider"
                        >
                            Cliente
                        </th>
                        <th
                            class="px-6 py-3 text-left text-sm font-semibold text-gray-700 uppercase tracking-wider"
                        >
                            Total
                        </th>
                        <th
                            class="px-6 py-3 text-left text-sm font-semibold text-gray-700 uppercase tracking-wider"
                        >
                            Fecha
                        </th>
                        <th
                            class="px-6 py-3 text-left text-sm font-semibold text-gray-700 uppercase tracking-wider"
                        >
                            Estado
                        </th>
                    </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-100">
                    <tr
                        v-for="order in orders"
                        :key="order.id"
                        class="transition-colors duration-200 hover:bg-gray-50"
                    >
                        <td
                            class="px-6 py-4 whitespace-nowrap text-sm text-gray-900 font-medium"
                        >
                            {{ order.id }}
                        </td>
                        <td
                            class="px-6 py-4 whitespace-nowrap text-sm text-gray-900"
                        >
                            {{ order.user_name }}
                        </td>
                        <td
                            class="px-6 py-4 whitespace-nowrap text-sm text-gray-900"
                        >
                            {{ formatCurrency(order.total) }}
                        </td>
                        <td
                            class="px-6 py-4 whitespace-nowrap text-sm text-gray-900"
                        >
                            {{ order.created_at }}
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm">
                            <span
                                :class="{
                                    'px-2 py-1 rounded-full text-xs font-medium': true,
                                    'bg-green-100 text-green-800':
                                        order.status === 'Completado',
                                    'bg-yellow-100 text-yellow-800':
                                        order.status === 'Pendiente',
                                    'bg-red-100 text-red-800':
                                        order.status === 'Cancelado',
                                }"
                            >
                                {{ order.status }}
                            </span>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</template>

<script setup>
defineProps({
    orders: Array,
});

const formatCurrency = (amount) => {
    return new Intl.NumberFormat("es-ES", {
        style: "currency",
        currency: "EUR",
    }).format(amount || 0);
};
</script>

<style scoped>
table {
    width: 100%;
    border-collapse: separate;
    border-spacing: 0;
    border-radius: 0.5rem;
    overflow: hidden;
}

th,
td {
    text-align: left;
}

thead th {
    border-bottom-width: 2px;
}

tbody tr:nth-child(even) {
    background-color: #f9fafb;
}

tbody tr:hover {
    background-color: #f3f4f6;
}
</style>
