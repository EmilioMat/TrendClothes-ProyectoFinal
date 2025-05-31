<template>
    <AdminLayout>
        <div class="p-4">
            <!-- Resumen de métricas -->
            <div
                class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 mb-6"
            >
                <!-- Tarjeta de Usuarios -->
                <div
                    class="bg-white p-6 rounded-xl shadow-lg hover:shadow-xl transition-shadow duration-300"
                >
                    <div class="flex items-center">
                        <div
                            class="p-3 rounded-full bg-blue-100 text-blue-600 mr-4"
                        >
                            <svg
                                class="w-8 h-8"
                                fill="currentColor"
                                viewBox="0 0 24 24"
                            >
                                <path
                                    d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8zm0-14c-3.31 0-6 2.69-6 6s2.69 6 6 6 6-2.69 6-6-2.69-6-6-6z"
                                />
                            </svg>
                        </div>
                        <div>
                            <p class="text-gray-500 text-sm">
                                Usuarios Totales
                            </p>
                            <p class="text-3xl font-bold text-gray-800">
                                {{ formatNumber(totalUsers) }}
                            </p>
                        </div>
                    </div>
                </div>

                <!-- Tarjeta de Ventas -->
                <div
                    class="bg-white p-6 rounded-xl shadow-lg hover:shadow-xl transition-shadow duration-300"
                >
                    <div class="flex items-center">
                        <div
                            class="p-3 rounded-full bg-green-100 text-green-600 mr-4"
                        >
                            <svg
                                class="w-8 h-8"
                                fill="currentColor"
                                viewBox="0 0 24 24"
                            >
                                <path
                                    d="M11 9h2V6h3V4h-3V1h-2v3H8v2h3v3zm-4 9c-1.1 0-1.99.9-1.99 2S5.9 22 7 22s2-.9 2-2-1-2-2-2zm10 0c-1.1 0-1.99.9-1.99 2s.89 2 1.99 2 2-.9 2-2-.9-2-2-2zm-9.83-3.25.03-.12.9-1.63h7.45c.75 0 1.41-.41 1.75-1.03l3.86-7.01L19.42 4h-.01l-1.1 2-2.76 5H8.53l-.13-.27L6.16 6l-.95-2-.94-2H1v2 ragingh2l3.6 7.59-1.35 2.45c-.16.28-.25.61-.25.96 0 1.1.9 2 2 2h12v-2H7.42c-.13 0-.25-.11-.25-.25z"
                                />
                            </svg>
                        </div>
                        <div>
                            <p class="text-gray-500 text-sm">Ventas Totales</p>
                            <p class="text-3xl font-bold text-gray-800">
                                {{ formatNumber(totalSales) }}
                            </p>
                        </div>
                    </div>
                </div>

                <!-- Tarjeta de Ingresos -->
                <div
                    class="bg-white p-6 rounded-xl shadow-lg hover:shadow-xl transition-shadow duration-300"
                >
                    <div class="flex items-center">
                        <div
                            class="p-3 rounded-full bg-purple-100 text-purple-600 mr-4"
                        >
                            <svg
                                class="w-8 h-8"
                                fill="currentColor"
                                viewBox="0 0 24 24"
                            >
                                <path
                                    d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8zm.31-8.86c-1.77-.45-2.34-.94-2.34-1.67 0-.84.79-1.43 2.1-1.43 1.38 0 1.9.66 1.94 1.64h1.71c-.05-1.34-.87-2.57-2.49-2.97V5H10.9v1.69c-1.51.32-2.72 1.3-2.72 2.81 0 1.79 1.49 2.69 3.66 3.21 1.95.46 2.34 1.15 2.34 1.87 0 .53-.39 1.39-2.1 1.39-1.6 0-2.23-.72-2.32-1.64H8.04c.1 1.7 1.36 2.66 2.86 2.97V19h2.34v-1.67c1.52-.29 2.72-1.16 2.73-2.77-.01-2.2-1.9-2.96-3.66-3.42z"
                                />
                            </svg>
                        </div>
                        <div>
                            <p class="text-gray-500 text-sm">
                                Ingresos Totales
                            </p>
                            <p class="text-3xl font-bold text-gray-800">
                                {{ formatCurrency(totalIncome) }}
                            </p>
                        </div>
                    </div>
                </div>

                <!-- Tarjeta de Productos -->
                <div
                    class="bg-white p-6 rounded-xl shadow-lg hover:shadow-xl transition-shadow duration-300"
                >
                    <div class="flex items-center">
                        <div
                            class="p-3 rounded-full bg-orange-100 text-orange-600 mr-4"
                        >
                            <svg
                                class="w-8 h-8"
                                fill="currentColor"
                                viewBox="0 0 24 24"
                            >
                                <path
                                    d="M21 7H7v14h14V7zm-2 12h-10V9h10v10zM3 9H1v14h14v-2H3V9zm14-6h-4.18C14.4 1.84 13.3 1 12 1c-1.3 0-2.4.84-2.82 2H3v2h18V3h-2z"
                                />
                            </svg>
                        </div>
                        <div>
                            <p class="text-gray-500 text-sm">
                                Productos Totales
                            </p>
                            <p class="text-3xl font-bold text-gray-800">
                                {{ formatNumber(totalProducts) }}
                            </p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Gráfico de Ventas por Día -->
            <div class="bg-white p-6 rounded-xl shadow-lg mb-6">
                <h3 class="text-xl font-semibold mb-4 text-gray-800">
                    Ventas por Día (Últimos 7 días)
                </h3>
                <div
                    v-if="!salesByDay.length"
                    class="text-center text-gray-500"
                >
                    No hay datos de ventas disponibles para los últimos 7 días.
                </div>
                <div v-else class="chart-container">
                    <canvas id="salesChart"></canvas>
                </div>
            </div>

            <!-- Últimos Pedidos y Productos Más Vendidos -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <!-- Últimos Pedidos (Izquierda) -->
                <div
                    class="bg-white p-6 rounded-xl shadow-lg h-80 md:h-96 overflow-auto"
                >
                    <h3 class="text-lg font-semibold mb-4 text-gray-800">
                        Últimos Pedidos
                    </h3>
                    <div
                        v-if="recentOrders.length === 0"
                        class="text-center text-gray-500"
                    >
                        No hay pedidos recientes disponibles.
                    </div>
                    <div v-else>
                        <table class="min-w-full divide-y divide-gray-200">
                            <thead class="bg-gray-50">
                                <tr>
                                    <th
                                        class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                                    >
                                        ID
                                    </th>
                                    <th
                                        class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                                    >
                                        Cliente
                                    </th>
                                    <th
                                        class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                                    >
                                        Total
                                    </th>
                                    <th
                                        class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                                    >
                                        Fecha
                                    </th>
                                    <th
                                        class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                                    >
                                        Estado
                                    </th>
                                </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                                <tr
                                    v-for="order in recentOrders"
                                    :key="order.id"
                                >
                                    <td
                                        class="px-4 py-2 whitespace-nowrap text-sm text-gray-900"
                                    >
                                        {{ order.id }}
                                    </td>
                                    <td
                                        class="px-4 py-2 whitespace-nowrap text-sm text-gray-900"
                                    >
                                        {{ order.user_name }}
                                    </td>
                                    <td
                                        class="px-4 py-2 whitespace-nowrap text-sm text-gray-900"
                                    >
                                        {{ formatCurrency(order.total) }}
                                    </td>
                                    <td
                                        class="px-4 py-2 whitespace-nowrap text-sm text-gray-900"
                                    >
                                        {{ order.created_at }}
                                    </td>
                                    <td
                                        class="px-4 py-2 whitespace-nowrap text-sm text-gray-900"
                                    >
                                        {{ order.status }}
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Productos Más Vendidos (Derecha) -->
                <div class="bg-white p-6 rounded-xl shadow-lg h-80 md:h-96">
                    <h3 class="text-lg font-semibold mb-4 text-gray-800">
                        Productos Más Vendidos
                    </h3>
                    <div
                        v-if="topProducts.length === 0"
                        class="text-center text-gray-500"
                    >
                        No hay datos de productos vendidos disponibles.
                    </div>
                    <div v-else class="chart-container">
                        <canvas id="topProductsChart"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </AdminLayout>
</template>

<script setup>
import { onMounted, ref } from "vue";
import { Chart } from "chart.js/auto";
import AdminLayout from "./Components/AdminLayout.vue";

// Recibir props desde el servidor (Laravel + Inertia)
const props = defineProps({
    totalUsers: {
        type: Number,
        default: 0,
    },
    totalProducts: {
        type: Number,
        default: 0,
    },
    totalSales: {
        type: Number,
        default: 0,
    },
    totalIncome: {
        type: Number,
        default: 0,
    },
    salesByDay: {
        type: Array,
        default: () => [],
    },
    recentOrders: {
        type: Array,
        default: () => [],
    },
    topProducts: {
        type: Array,
        default: () => [],
    },
});

// Datos reactivos
const totalUsers = ref(props.totalUsers || 0);
const totalProducts = ref(props.totalProducts || 0);
const totalSales = ref(props.totalSales || 0);
const totalIncome = ref(props.totalIncome || 0);
const salesData = ref([]);
const daysOfWeek = ref([]);
const recentOrders = ref(props.recentOrders || []);
const topProducts = ref(props.topProducts || []);

// Funciones de formato
const formatNumber = (num) => {
    return new Intl.NumberFormat("es-ES").format(num || 0);
};

const formatCurrency = (amount) => {
    return new Intl.NumberFormat("es-ES", {
        style: "currency",
        currency: "EUR",
    }).format(amount || 0);
};

// Procesar los datos para el gráfico de ventas por día
const processSalesData = () => {
    console.log("salesByDay:", props.salesByDay);
    const sales = props.salesByDay;
    if (sales && Array.isArray(sales)) {
        salesData.value = sales.map((item) => item.count || 0);
        daysOfWeek.value = sales.map((item) => item.day || "Desconocido");
        initSalesChart();
    } else {
        console.error(
            "Los datos de ventas no están disponibles o no son un array."
        );
        daysOfWeek.value = [
            "Lunes",
            "Martes",
            "Miércoles",
            "Jueves",
            "Viernes",
            "Sábado",
            "Domingo",
        ];
        salesData.value = [0, 0, 0, 0, 0, 0, 0];
        initSalesChart();
    }
};

// Procesar los datos para el gráfico de productos más vendidos
const processTopProductsData = () => {
    console.log("topProducts:", props.topProducts);
    if (topProducts.value && Array.isArray(topProducts.value)) {
        initTopProductsChart();
    } else {
        console.error(
            "Los datos de productos más vendidos no están disponibles o no son un array."
        );
    }
};

// Inicializar gráfico de ventas por día
let salesChartInstance;
const initSalesChart = () => {
    const canvas = document.getElementById("salesChart");
    if (!canvas) {
        console.error('No se encontró el elemento con ID "salesChart"');
        return;
    }
    const ctx = canvas.getContext("2d");
    if (!ctx) {
        console.error("No se pudo obtener el contexto 2D del canvas");
        return;
    }

    if (salesChartInstance) salesChartInstance.destroy();

    salesChartInstance = new Chart(ctx, {
        type: "bar",
        data: {
            labels: daysOfWeek.value,
            datasets: [
                {
                    label: "Ventas",
                    data: salesData.value,
                    backgroundColor: "#4f46e5",
                },
            ],
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: {
                    beginAtZero: true,
                },
            },
            plugins: {
                legend: {
                    display: true,
                },
            },
        },
    });
};

// Inicializar gráfico de productos más vendidos
let topProductsChartInstance;
const initTopProductsChart = () => {
    const canvas = document.getElementById("topProductsChart");
    if (!canvas) {
        console.error('No se encontró el elemento con ID "topProductsChart"');
        return;
    }
    const ctx = canvas.getContext("2d");
    if (!ctx) {
        console.error("No se pudo obtener el contexto 2D del canvas");
        return;
    }

    if (topProductsChartInstance) topProductsChartInstance.destroy();

    topProductsChartInstance = new Chart(ctx, {
        type: "bar",
        data: {
            labels: topProducts.value.map((item) => item.product_name),
            datasets: [
                {
                    label: "Unidades Vendidas",
                    data: topProducts.value.map((item) => item.total_sold),
                    backgroundColor: "#10b981",
                },
            ],
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: {
                    beginAtZero: true,
                },
            },
            plugins: {
                legend: {
                    display: true,
                },
            },
        },
    });
};

onMounted(() => {
    processSalesData();
    processTopProductsData();
});
</script>

<style scoped>
.chart-container {
    position: relative;
    width: 100%;
    height: 300px;
}

.chart-container canvas {
    width: 100% !important;
    height: 100% !important;
}

table {
    width: 100%;
    border-collapse: collapse;
}

th,
td {
    text-align: left;
    padding: 8px;
}

thead th {
    background-color: #f9fafb;
    font-size: 0.75rem;
    text-transform: uppercase;
    color: #6b7280;
}

tbody tr:hover {
    background-color: #f3f4f6;
}
</style>

<style scoped>
.chart-container {
    position: relative;
    width: 100%;
    height: 300px;
}

.chart-container canvas {
    width: 100% !important;
    height: 100% !important;
}

table {
    width: 100%;
    border-collapse: collapse;
}

th,
td {
    text-align: left;
    padding: 8px;
}

thead th {
    background-color: #f9fafb;
    font-size: 0.75rem;
    text-transform: uppercase;
    color: #6b7280;
}

tbody tr:hover {
    background-color: #f3f4f6;
}
</style>
