// Tech Stack Data for AI-Optimized Development Guide

export const techStacks = [
  {
    id: 'static-sites',
    title: 'Static Sites',
    category: 'Web Applications',
    usage: 'High',
    examples: 'Personal websites, blogs, documentation',
    description: 'Modern static site generation with optimal performance and developer experience.',
    primaryTech: ['Astro', 'Next.js', 'Tailwind CSS'],
    aiCompatibility: 'Excellent',
    complexity: 'Low',
    wordCount: '4,000+',
    highlights: [
      'Astro for component-agnostic architecture',
      'Next.js static export for React-based sites',
      'Tailwind CSS for utility-first styling',
      'Vercel/Netlify deployment optimization'
    ]
  },
  {
    id: 'single-page-apps',
    title: 'Single Page Apps (SPAs)',
    category: 'Web Applications',
    usage: 'High',
    examples: 'Interactive dashboards, web applications',
    description: 'Modern SPA development with comprehensive state management and routing.',
    primaryTech: ['React', 'Vue.js', 'Svelte'],
    aiCompatibility: 'Excellent',
    complexity: 'Medium',
    wordCount: '6,000+',
    highlights: [
      'React with TypeScript for type safety',
      'Zustand for state management',
      'React Router for navigation',
      'Comprehensive testing strategies'
    ]
  },
  {
    id: 'progressive-web-apps',
    title: 'Progressive Web Apps (PWAs)',
    category: 'Web Applications',
    usage: 'High',
    examples: 'Mobile-first web apps, offline-capable applications',
    description: 'Native-like web applications with offline functionality and device integration.',
    primaryTech: ['React', 'Workbox', 'Service Workers'],
    aiCompatibility: 'Excellent',
    complexity: 'Medium-High',
    wordCount: '5,500+',
    highlights: [
      'Service workers for offline functionality',
      'Workbox for PWA optimization',
      'Push notifications and background sync',
      'App manifest and installation prompts'
    ]
  },
  {
    id: 'server-side-rendered',
    title: 'Server-Side Rendered (SSR)',
    category: 'Web Applications',
    usage: 'High',
    examples: 'E-commerce, blogs, news sites',
    description: 'Full-stack applications with server-side rendering for optimal SEO and performance.',
    primaryTech: ['Next.js', 'Nuxt.js', 'SvelteKit'],
    aiCompatibility: 'Excellent',
    complexity: 'High',
    wordCount: '5,800+',
    highlights: [
      'Next.js App Router for full-stack development',
      'Prisma for type-safe database access',
      'NextAuth.js for authentication',
      'Advanced SEO and performance optimization'
    ]
  },
  {
    id: 'jamstack-sites',
    title: 'Jamstack Sites',
    category: 'Web Applications',
    usage: 'High',
    examples: 'Static + APIs (Gatsby, Astro sites)',
    description: 'Modern web architecture combining static generation with API-driven content.',
    primaryTech: ['Astro', 'Next.js', 'Gatsby'],
    aiCompatibility: 'Excellent',
    complexity: 'Medium',
    wordCount: '5,200+',
    highlights: [
      'Astro islands architecture',
      'Headless CMS integration (Contentful, Strapi)',
      'Serverless functions for dynamic features',
      'CDN optimization and edge computing'
    ]
  },
  {
    id: 'web-based-saas',
    title: 'Web-Based SaaS',
    category: 'Web Applications',
    usage: 'High',
    examples: 'Stripe Dashboard, Notion, Linear',
    description: 'Enterprise-grade SaaS applications with multi-tenancy and subscription management.',
    primaryTech: ['Next.js', 'Prisma', 'Stripe'],
    aiCompatibility: 'Excellent',
    complexity: 'High',
    wordCount: '6,500+',
    highlights: [
      'Multi-tenant architecture patterns',
      'Stripe integration for billing',
      'Enterprise authentication (Auth0, Clerk)',
      'Real-time collaboration features'
    ]
  },
  {
    id: 'ecommerce-platforms',
    title: 'E-commerce Platforms',
    category: 'Web Applications',
    usage: 'High',
    examples: 'Shopify stores, marketplaces',
    description: 'Comprehensive e-commerce solutions with payment processing and inventory management.',
    primaryTech: ['Next.js Commerce', 'Shopify Hydrogen', 'Medusa.js'],
    aiCompatibility: 'Excellent',
    complexity: 'High',
    wordCount: '6,800+',
    highlights: [
      'Headless commerce architecture',
      'Payment processing (Stripe, PayPal)',
      'Inventory management and fulfillment',
      'PCI DSS compliance and security'
    ]
  },
  {
    id: 'dashboards-analytics',
    title: 'Dashboards/Analytics',
    category: 'Web Applications',
    usage: 'High',
    examples: 'Admin panels, BI tools',
    description: 'Business intelligence applications with data visualization and real-time processing.',
    primaryTech: ['Next.js', 'Chart.js', 'D3.js'],
    aiCompatibility: 'Excellent',
    complexity: 'High',
    wordCount: '7,200+',
    highlights: [
      'Real-time data processing with WebSockets',
      'Advanced data visualization (Chart.js, D3.js)',
      'Time-series databases (InfluxDB, ClickHouse)',
      'OLAP and business intelligence features'
    ]
  }
];

export const categories = [
  {
    id: 'web-applications',
    name: 'Web Applications',
    description: 'Modern web development frameworks and architectures',
    count: 8,
    completed: 8,
    total: 14
  },
  {
    id: 'mobile-desktop-cli',
    name: 'Mobile, Desktop & CLI',
    description: 'Cross-platform and native application development',
    count: 0,
    completed: 0,
    total: 14
  },
  {
    id: 'api-backend-games',
    name: 'API/Backend & Games',
    description: 'Server-side development and game development frameworks',
    count: 0,
    completed: 0,
    total: 14
  },
  {
    id: 'specialized-apps',
    name: 'Specialized Applications',
    description: 'Browser extensions, AI/ML, and specialized development',
    count: 0,
    completed: 0,
    total: 12
  }
];

export const usageFrequency = {
  'High': techStacks.filter(stack => stack.usage === 'High'),
  'Medium': techStacks.filter(stack => stack.usage === 'Medium'),
  'Low': techStacks.filter(stack => stack.usage === 'Low')
};

export const aiCompatibilityLevels = {
  'Excellent': techStacks.filter(stack => stack.aiCompatibility === 'Excellent'),
  'Good': techStacks.filter(stack => stack.aiCompatibility === 'Good'),
  'Fair': techStacks.filter(stack => stack.aiCompatibility === 'Fair')
};

