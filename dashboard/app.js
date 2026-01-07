/**
 * SOS-WRITERS Dashboard Application
 * A comprehensive writing management platform
 */

// Application State
const AppState = {
    currentPage: 'dashboard',
    theme: 'dark',
    projects: [],
    dailyGoal: 2000,
    weeklyGoal: 10000,
    sessionStartTime: null,
    sessionWords: 0,
    editorInterval: null
};

// Sample Data (replace with API calls in production)
const SampleData = {
    projects: [
        {
            id: 1,
            name: 'Book 1: The Beginning',
            icon: '📕',
            words: 45000,
            target: 80000,
            chapters: 12,
            status: 'drafting'
        },
        {
            id: 2,
            name: 'Book 2: The Journey',
            icon: '📗',
            words: 22000,
            target: 80000,
            chapters: 8,
            status: 'outlining'
        },
        {
            id: 3,
            name: 'Book 3: The Return',
            icon: '📘',
            words: 5000,
            target: 80000,
            chapters: 3,
            status: 'planning'
        }
    ],
    weeklyProgress: [1200, 1800, 2100, 1500, 2300, 1900, 800],
    monthlyProgress: [25000, 28000, 32000, 35000],
    characters: [
        { name: 'Alex Morgan', role: 'Protagonist', icon: '🦸' },
        { name: 'Dr. Sarah Chen', role: 'Mentor', icon: '👩‍🔬' },
        { name: 'Marcus Black', role: 'Antagonist', icon: '🦹' },
        { name: 'Luna', role: 'Sidekick', icon: '🐱' }
    ],
    chapters: [
        { id: 1, title: 'Prologue', words: 2500, status: 'complete' },
        { id: 2, title: 'Chapter 1: Dawn', words: 4200, status: 'complete' },
        { id: 3, title: 'Chapter 2: Discovery', words: 3800, status: 'complete' },
        { id: 4, title: 'Chapter 3: The Call', words: 4100, status: 'editing' },
        { id: 5, title: 'Chapter 4: Departure', words: 2100, status: 'drafting' },
        { id: 6, title: 'Chapter 5: New World', words: 0, status: 'outline' }
    ]
};

// Initialize Application
document.addEventListener('DOMContentLoaded', () => {
    initNavigation();
    initTheme();
    initMenuToggle();
    loadDashboardData();
    initCharts();
    initWritingSession();
    initGoals();
    initCalendar();
    initSeriesBible();
    initSettings();
});

// Navigation System
function initNavigation() {
    const navItems = document.querySelectorAll('.nav-item[data-page]');
    const linkItems = document.querySelectorAll('.link-small[data-page]');

    navItems.forEach(item => {
        item.addEventListener('click', (e) => {
            e.preventDefault();
            const page = item.dataset.page;
            navigateToPage(page);
        });
    });

    linkItems.forEach(item => {
        item.addEventListener('click', (e) => {
            e.preventDefault();
            const page = item.dataset.page;
            navigateToPage(page);
        });
    });
}

function navigateToPage(pageName) {
    // Update nav active state
    document.querySelectorAll('.nav-item').forEach(nav => {
        nav.classList.remove('active');
        if (nav.dataset.page === pageName) {
            nav.classList.add('active');
        }
    });

    // Update page visibility
    document.querySelectorAll('.page').forEach(page => {
        page.classList.remove('active');
    });

    const targetPage = document.getElementById(`page-${pageName}`);
    if (targetPage) {
        targetPage.classList.add('active');
    }

    // Update header title
    const pageTitle = document.querySelector('.page-title');
    if (pageTitle) {
        pageTitle.textContent = formatPageTitle(pageName);
    }

    AppState.currentPage = pageName;

    // Close mobile menu
    document.querySelector('.sidebar').classList.remove('open');
}

function formatPageTitle(pageName) {
    const titles = {
        dashboard: 'Dashboard',
        projects: 'Projects',
        writing: 'Writing Session',
        analytics: 'Writing Analytics',
        sales: 'Sales & Revenue',
        calendar: 'Launch Calendar',
        bible: 'Series Bible',
        settings: 'Settings'
    };
    return titles[pageName] || pageName;
}

// Theme System
function initTheme() {
    const savedTheme = localStorage.getItem('sos-theme') || 'dark';
    setTheme(savedTheme);

    const themeSelect = document.getElementById('theme-select');
    if (themeSelect) {
        themeSelect.value = savedTheme;
        themeSelect.addEventListener('change', (e) => {
            setTheme(e.target.value);
        });
    }
}

function setTheme(theme) {
    if (theme === 'auto') {
        const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
        document.documentElement.dataset.theme = prefersDark ? 'dark' : 'light';
    } else {
        document.documentElement.dataset.theme = theme;
    }
    localStorage.setItem('sos-theme', theme);
    AppState.theme = theme;
}

// Mobile Menu Toggle
function initMenuToggle() {
    const menuToggle = document.getElementById('menu-toggle');
    const sidebar = document.querySelector('.sidebar');

    if (menuToggle && sidebar) {
        menuToggle.addEventListener('click', () => {
            sidebar.classList.toggle('open');
        });

        // Close on outside click
        document.addEventListener('click', (e) => {
            if (!sidebar.contains(e.target) && !menuToggle.contains(e.target)) {
                sidebar.classList.remove('open');
            }
        });
    }
}

// Dashboard Data
function loadDashboardData() {
    // KPI Updates
    const totalProjects = SampleData.projects.length;
    const totalWords = SampleData.projects.reduce((sum, p) => sum + p.words, 0);
    const streak = calculateStreak();
    const monthRevenue = calculateMonthRevenue();

    updateKPI('kpi-projects', totalProjects);
    updateKPI('kpi-words', formatNumber(totalWords));
    updateKPI('kpi-streak', streak);
    updateKPI('kpi-revenue', `$${formatNumber(monthRevenue)}`);

    // Load project list
    loadProjectList();
    loadProjectsGrid();
}

function updateKPI(id, value) {
    const element = document.getElementById(id);
    if (element) {
        animateValue(element, value);
    }
}

function animateValue(element, finalValue) {
    const isNumber = typeof finalValue === 'number' || /^\d+$/.test(finalValue);

    if (isNumber) {
        const numValue = parseInt(finalValue);
        let current = 0;
        const increment = Math.ceil(numValue / 30);
        const timer = setInterval(() => {
            current += increment;
            if (current >= numValue) {
                element.textContent = finalValue;
                clearInterval(timer);
            } else {
                element.textContent = current;
            }
        }, 30);
    } else {
        element.textContent = finalValue;
    }
}

function formatNumber(num) {
    if (num >= 1000000) {
        return (num / 1000000).toFixed(1) + 'M';
    }
    if (num >= 1000) {
        return (num / 1000).toFixed(1) + 'K';
    }
    return num.toLocaleString();
}

function calculateStreak() {
    // Simulated streak calculation
    return 14;
}

function calculateMonthRevenue() {
    // Simulated revenue
    return 2450;
}

// Project List (Dashboard)
function loadProjectList() {
    const container = document.getElementById('project-list');
    if (!container) return;

    container.innerHTML = SampleData.projects.map(project => {
        const progress = Math.round((project.words / project.target) * 100);
        return `
            <div class="project-item" data-project-id="${project.id}">
                <span class="project-icon">${project.icon}</span>
                <div class="project-info">
                    <div class="project-name">${project.name}</div>
                    <div class="project-meta">${formatNumber(project.words)} / ${formatNumber(project.target)} words</div>
                </div>
                <div class="project-progress">
                    <div class="progress-bar">
                        <div class="progress-fill" style="width: ${progress}%"></div>
                    </div>
                </div>
            </div>
        `;
    }).join('');
}

// Projects Grid (Projects Page)
function loadProjectsGrid() {
    const container = document.getElementById('projects-grid');
    if (!container) return;

    container.innerHTML = SampleData.projects.map(project => {
        const progress = Math.round((project.words / project.target) * 100);
        const statusColors = {
            planning: 'var(--accent-purple)',
            outlining: 'var(--accent-orange)',
            drafting: 'var(--accent-blue)',
            editing: 'var(--accent-green)',
            complete: 'var(--accent-green)'
        };

        return `
            <div class="project-card" data-project-id="${project.id}">
                <div class="project-card-header">
                    <div class="project-card-title">${project.icon} ${project.name}</div>
                    <div class="project-card-meta">
                        <span style="color: ${statusColors[project.status]}">${project.status.toUpperCase()}</span>
                    </div>
                </div>
                <div class="project-card-body">
                    <div class="project-card-stats">
                        <div class="stat-item">
                            <div class="stat-value">${formatNumber(project.words)}</div>
                            <div class="stat-label">Words</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-value">${project.chapters}</div>
                            <div class="stat-label">Chapters</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-value">${progress}%</div>
                            <div class="stat-label">Complete</div>
                        </div>
                    </div>
                    <div class="project-card-progress">
                        <div class="progress-label">
                            <span>Progress</span>
                            <span>${formatNumber(project.words)} / ${formatNumber(project.target)}</span>
                        </div>
                        <div class="progress-bar">
                            <div class="progress-fill" style="width: ${progress}%"></div>
                        </div>
                    </div>
                </div>
            </div>
        `;
    }).join('');
}

// Charts
function initCharts() {
    initProgressChart();
    initTimeChart();
    initProjectChart();
    initRevenueChart();
    initHeatmap();
}

function initProgressChart() {
    const ctx = document.getElementById('progress-chart');
    if (!ctx) return;

    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
            datasets: [{
                label: 'Words Written',
                data: SampleData.weeklyProgress,
                backgroundColor: 'rgba(88, 166, 255, 0.8)',
                borderColor: 'rgba(88, 166, 255, 1)',
                borderWidth: 1,
                borderRadius: 6
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    display: false
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    grid: {
                        color: 'rgba(255, 255, 255, 0.1)'
                    },
                    ticks: {
                        color: '#8b949e'
                    }
                },
                x: {
                    grid: {
                        display: false
                    },
                    ticks: {
                        color: '#8b949e'
                    }
                }
            }
        }
    });
}

function initTimeChart() {
    const ctx = document.getElementById('time-chart');
    if (!ctx) return;

    const hours = Array.from({ length: 24 }, (_, i) => `${i}:00`);
    const productivity = [
        10, 5, 3, 2, 3, 8, 25, 45, 65, 80, 75, 60,
        55, 70, 85, 90, 75, 60, 45, 35, 30, 25, 20, 15
    ];

    new Chart(ctx, {
        type: 'line',
        data: {
            labels: hours,
            datasets: [{
                label: 'Productivity',
                data: productivity,
                borderColor: 'rgba(63, 185, 80, 1)',
                backgroundColor: 'rgba(63, 185, 80, 0.2)',
                fill: true,
                tension: 0.4
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    display: false
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    grid: {
                        color: 'rgba(255, 255, 255, 0.1)'
                    },
                    ticks: {
                        color: '#8b949e'
                    }
                },
                x: {
                    grid: {
                        display: false
                    },
                    ticks: {
                        color: '#8b949e',
                        maxTicksLimit: 8
                    }
                }
            }
        }
    });
}

function initProjectChart() {
    const ctx = document.getElementById('project-chart');
    if (!ctx) return;

    new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: SampleData.projects.map(p => p.name.split(':')[1]?.trim() || p.name),
            datasets: [{
                data: SampleData.projects.map(p => p.words),
                backgroundColor: [
                    'rgba(88, 166, 255, 0.8)',
                    'rgba(63, 185, 80, 0.8)',
                    'rgba(163, 113, 247, 0.8)'
                ],
                borderWidth: 0
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: {
                        color: '#8b949e',
                        padding: 16
                    }
                }
            }
        }
    });
}

function initRevenueChart() {
    const ctx = document.getElementById('revenue-chart');
    if (!ctx) return;

    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    const revenue = [1200, 1800, 2400, 2100, 2800, 3200, 2900, 3500, 3100, 2700, 3000, 2450];

    new Chart(ctx, {
        type: 'line',
        data: {
            labels: months,
            datasets: [{
                label: 'Revenue',
                data: revenue,
                borderColor: 'rgba(163, 113, 247, 1)',
                backgroundColor: 'rgba(163, 113, 247, 0.2)',
                fill: true,
                tension: 0.3
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    display: false
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    grid: {
                        color: 'rgba(255, 255, 255, 0.1)'
                    },
                    ticks: {
                        color: '#8b949e',
                        callback: value => '$' + value
                    }
                },
                x: {
                    grid: {
                        display: false
                    },
                    ticks: {
                        color: '#8b949e'
                    }
                }
            }
        }
    });

    // Update sales KPIs
    document.getElementById('sales-total')?.textContent &&
        (document.getElementById('sales-total').textContent = '$' + formatNumber(revenue.reduce((a, b) => a + b, 0)));
    document.getElementById('sales-month')?.textContent &&
        (document.getElementById('sales-month').textContent = '$' + formatNumber(revenue[revenue.length - 1]));
    document.getElementById('sales-units')?.textContent &&
        (document.getElementById('sales-units').textContent = formatNumber(Math.floor(revenue.reduce((a, b) => a + b, 0) / 9.99)));
}

function initHeatmap() {
    const container = document.getElementById('calendar-heatmap');
    if (!container) return;

    // Generate 365 days of fake data
    const days = [];
    for (let i = 0; i < 365; i++) {
        const level = Math.floor(Math.random() * 5);
        days.push(`<div class="heatmap-day level-${level}" title="Day ${i + 1}"></div>`);
    }
    container.innerHTML = days.join('');
}

// Writing Session
function initWritingSession() {
    const editor = document.getElementById('editor');
    if (!editor) return;

    // Load chapters
    loadChapterOutline();

    // Word count tracking
    editor.addEventListener('input', () => {
        const words = countWords(editor.value);
        document.getElementById('session-words').textContent = words;
        AppState.sessionWords = words;
    });

    // Start session timer
    AppState.sessionStartTime = new Date();
    AppState.editorInterval = setInterval(updateSessionTime, 1000);

    // Quick actions
    document.getElementById('action-write')?.addEventListener('click', () => {
        navigateToPage('writing');
    });

    document.getElementById('action-new')?.addEventListener('click', () => {
        alert('Create New Project - Coming soon!');
    });

    document.getElementById('action-compile')?.addEventListener('click', () => {
        alert('Compile Manuscript - Use GitHub Actions workflow!');
    });

    document.getElementById('action-backup')?.addEventListener('click', () => {
        alert('Backup to Cloud - Coming soon!');
    });
}

function loadChapterOutline() {
    const container = document.getElementById('chapter-outline');
    if (!container) return;

    container.innerHTML = SampleData.chapters.map(chapter => {
        const statusIcon = {
            complete: '✅',
            editing: '✏️',
            drafting: '📝',
            outline: '📋'
        };
        return `
            <div class="chapter-item" data-chapter-id="${chapter.id}">
                ${statusIcon[chapter.status]} ${chapter.title}
            </div>
        `;
    }).join('');

    // Chapter click handler
    container.querySelectorAll('.chapter-item').forEach(item => {
        item.addEventListener('click', () => {
            container.querySelectorAll('.chapter-item').forEach(c => c.classList.remove('active'));
            item.classList.add('active');
        });
    });
}

function countWords(text) {
    return text.trim().split(/\s+/).filter(word => word.length > 0).length;
}

function updateSessionTime() {
    if (!AppState.sessionStartTime) return;

    const now = new Date();
    const diff = Math.floor((now - AppState.sessionStartTime) / 1000);
    const minutes = Math.floor(diff / 60);
    const seconds = diff % 60;

    const timeDisplay = document.getElementById('session-time');
    if (timeDisplay) {
        timeDisplay.textContent = `${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}`;
    }
}

// Goals
function initGoals() {
    const addGoalBtn = document.getElementById('add-goal');
    if (addGoalBtn) {
        addGoalBtn.addEventListener('click', () => {
            const goalText = prompt('Enter your goal:');
            if (goalText) {
                addGoal(goalText);
            }
        });
    }

    // Checkbox handlers
    document.querySelectorAll('.goal-item input[type="checkbox"]').forEach(checkbox => {
        checkbox.addEventListener('change', (e) => {
            const goalItem = e.target.closest('.goal-item');
            if (e.target.checked) {
                goalItem.classList.add('completed');
            } else {
                goalItem.classList.remove('completed');
            }
        });
    });
}

function addGoal(text) {
    const goalsList = document.getElementById('goals-list');
    if (!goalsList) return;

    const goalId = `goal-${Date.now()}`;
    const goalHtml = `
        <div class="goal-item">
            <input type="checkbox" id="${goalId}">
            <label for="${goalId}">${text}</label>
        </div>
    `;
    goalsList.insertAdjacentHTML('beforeend', goalHtml);

    // Add checkbox handler
    const newCheckbox = document.getElementById(goalId);
    newCheckbox.addEventListener('change', (e) => {
        const goalItem = e.target.closest('.goal-item');
        if (e.target.checked) {
            goalItem.classList.add('completed');
        } else {
            goalItem.classList.remove('completed');
        }
    });
}

// Calendar
function initCalendar() {
    const container = document.getElementById('calendar-container');
    if (!container) return;

    const now = new Date();
    const currentMonth = now.getMonth();
    const currentYear = now.getFullYear();

    renderCalendar(container, currentMonth, currentYear);
}

function renderCalendar(container, month, year) {
    const months = ['January', 'February', 'March', 'April', 'May', 'June',
                    'July', 'August', 'September', 'October', 'November', 'December'];
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    const firstDay = new Date(year, month, 1).getDay();
    const daysInMonth = new Date(year, month + 1, 0).getDate();
    const today = new Date();

    let html = `
        <div class="calendar-header">
            <h3>${months[month]} ${year}</h3>
            <div class="calendar-nav">
                <button onclick="changeMonth(-1)">Prev</button>
                <button onclick="changeMonth(1)">Next</button>
            </div>
        </div>
        <div class="calendar-grid">
            ${days.map(d => `<div class="calendar-day-header">${d}</div>`).join('')}
    `;

    // Empty cells before first day
    for (let i = 0; i < firstDay; i++) {
        html += '<div class="calendar-day empty"></div>';
    }

    // Days of month
    for (let day = 1; day <= daysInMonth; day++) {
        const isToday = day === today.getDate() && month === today.getMonth() && year === today.getFullYear();
        const hasEvent = [5, 15, 20, 28].includes(day); // Sample events

        html += `
            <div class="calendar-day${isToday ? ' today' : ''}${hasEvent ? ' has-event' : ''}">
                <div class="calendar-day-number">${day}</div>
            </div>
        `;
    }

    html += '</div>';
    container.innerHTML = html;
}

// Global function for calendar navigation
window.changeMonth = function(delta) {
    // Implementation would track current month/year in state
    alert('Calendar navigation - Coming soon!');
};

// Series Bible
function initSeriesBible() {
    const tabBtns = document.querySelectorAll('.tab-btn');
    const content = document.getElementById('bible-content');

    if (!content) return;

    tabBtns.forEach(btn => {
        btn.addEventListener('click', () => {
            tabBtns.forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            loadBibleContent(btn.dataset.tab);
        });
    });

    // Load initial content
    loadBibleContent('characters');
}

function loadBibleContent(tab) {
    const content = document.getElementById('bible-content');
    if (!content) return;

    switch (tab) {
        case 'characters':
            content.innerHTML = `
                <div class="character-grid">
                    ${SampleData.characters.map(char => `
                        <div class="character-card">
                            <div class="character-avatar">${char.icon}</div>
                            <div class="character-name">${char.name}</div>
                            <div class="character-role">${char.role}</div>
                        </div>
                    `).join('')}
                </div>
            `;
            break;
        case 'locations':
            content.innerHTML = `
                <div class="character-grid">
                    <div class="character-card">
                        <div class="character-avatar">🏰</div>
                        <div class="character-name">The Citadel</div>
                        <div class="character-role">Main Setting</div>
                    </div>
                    <div class="character-card">
                        <div class="character-avatar">🌲</div>
                        <div class="character-name">Darkwood Forest</div>
                        <div class="character-role">Adventure Location</div>
                    </div>
                    <div class="character-card">
                        <div class="character-avatar">🏔️</div>
                        <div class="character-name">Mount Everwatch</div>
                        <div class="character-role">Climax Location</div>
                    </div>
                </div>
            `;
            break;
        case 'timeline':
            content.innerHTML = `
                <div style="padding: 20px;">
                    <h4 style="margin-bottom: 16px;">Story Timeline</h4>
                    <div style="border-left: 2px solid var(--accent-blue); padding-left: 20px;">
                        <div style="margin-bottom: 20px;">
                            <strong>Year 1</strong><br>
                            <span style="color: var(--text-secondary);">The Awakening - Main character discovers abilities</span>
                        </div>
                        <div style="margin-bottom: 20px;">
                            <strong>Year 2</strong><br>
                            <span style="color: var(--text-secondary);">The Training - Learning and preparation</span>
                        </div>
                        <div style="margin-bottom: 20px;">
                            <strong>Year 3</strong><br>
                            <span style="color: var(--text-secondary);">The Confrontation - Final battle begins</span>
                        </div>
                    </div>
                </div>
            `;
            break;
    }
}

// Settings
function initSettings() {
    const dailyGoalInput = document.getElementById('daily-goal');
    const weeklyGoalInput = document.getElementById('weekly-goal');
    const exportBtn = document.getElementById('export-data');
    const importBtn = document.getElementById('import-data');

    if (dailyGoalInput) {
        dailyGoalInput.value = localStorage.getItem('sos-daily-goal') || 2000;
        dailyGoalInput.addEventListener('change', (e) => {
            localStorage.setItem('sos-daily-goal', e.target.value);
            AppState.dailyGoal = parseInt(e.target.value);
        });
    }

    if (weeklyGoalInput) {
        weeklyGoalInput.value = localStorage.getItem('sos-weekly-goal') || 10000;
        weeklyGoalInput.addEventListener('change', (e) => {
            localStorage.setItem('sos-weekly-goal', e.target.value);
            AppState.weeklyGoal = parseInt(e.target.value);
        });
    }

    if (exportBtn) {
        exportBtn.addEventListener('click', exportData);
    }

    if (importBtn) {
        importBtn.addEventListener('click', importData);
    }
}

function exportData() {
    const data = {
        projects: SampleData.projects,
        settings: {
            dailyGoal: AppState.dailyGoal,
            weeklyGoal: AppState.weeklyGoal,
            theme: AppState.theme
        },
        exportDate: new Date().toISOString()
    };

    const blob = new Blob([JSON.stringify(data, null, 2)], { type: 'application/json' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `sos-writers-export-${new Date().toISOString().split('T')[0]}.json`;
    a.click();
    URL.revokeObjectURL(url);
}

function importData() {
    const input = document.createElement('input');
    input.type = 'file';
    input.accept = '.json';
    input.addEventListener('change', (e) => {
        const file = e.target.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = (e) => {
                try {
                    const data = JSON.parse(e.target.result);
                    console.log('Imported data:', data);
                    alert('Data imported successfully!');
                    location.reload();
                } catch (err) {
                    alert('Error importing data: ' + err.message);
                }
            };
            reader.readAsText(file);
        }
    });
    input.click();
}

// Search
const globalSearch = document.getElementById('global-search');
if (globalSearch) {
    globalSearch.addEventListener('input', (e) => {
        const query = e.target.value.toLowerCase();
        if (query.length > 2) {
            console.log('Searching for:', query);
            // Implement search logic
        }
    });
}

// New Project Button
const newProjectBtn = document.getElementById('new-project-btn');
if (newProjectBtn) {
    newProjectBtn.addEventListener('click', () => {
        alert('Create New Project - Coming soon!\n\nUse the templates in /templates to get started.');
    });
}

// Cleanup on page unload
window.addEventListener('beforeunload', () => {
    if (AppState.editorInterval) {
        clearInterval(AppState.editorInterval);
    }
});

console.log('SOS-WRITERS Dashboard initialized');
