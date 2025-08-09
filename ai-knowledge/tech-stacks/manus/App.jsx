import { useState, useMemo } from 'react'
import { Search, Filter, Code, Zap, Users, Star, ArrowRight, Github, ExternalLink, BookOpen, Layers, Target, TrendingUp } from 'lucide-react'
import { Button } from '@/components/ui/button.jsx'
import { Input } from '@/components/ui/input.jsx'
import { Badge } from '@/components/ui/badge.jsx'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card.jsx'
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs.jsx'
import { techStacks, categories, usageFrequency } from './data/techStacks.js'
import './App.css'

function App() {
  const [searchTerm, setSearchTerm] = useState('')
  const [selectedCategory, setSelectedCategory] = useState('all')
  const [selectedUsage, setSelectedUsage] = useState('all')
  const [selectedStack, setSelectedStack] = useState(null)

  const filteredStacks = useMemo(() => {
    return techStacks.filter(stack => {
      const matchesSearch = stack.title.toLowerCase().includes(searchTerm.toLowerCase()) ||
                           stack.description.toLowerCase().includes(searchTerm.toLowerCase()) ||
                           stack.primaryTech.some(tech => tech.toLowerCase().includes(searchTerm.toLowerCase()))
      
      const matchesCategory = selectedCategory === 'all' || stack.category.toLowerCase().replace(/[^a-z]/g, '-') === selectedCategory
      const matchesUsage = selectedUsage === 'all' || stack.usage === selectedUsage
      
      return matchesSearch && matchesCategory && matchesUsage
    })
  }, [searchTerm, selectedCategory, selectedUsage])

  const getUsageBadgeColor = (usage) => {
    switch (usage) {
      case 'High': return 'bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-200'
      case 'Medium': return 'bg-yellow-100 text-yellow-800 dark:bg-yellow-900 dark:text-yellow-200'
      case 'Low': return 'bg-blue-100 text-blue-800 dark:bg-blue-900 dark:text-blue-200'
      default: return 'bg-gray-100 text-gray-800 dark:bg-gray-900 dark:text-gray-200'
    }
  }

  const getComplexityColor = (complexity) => {
    switch (complexity) {
      case 'Low': return 'text-green-600 dark:text-green-400'
      case 'Medium': return 'text-yellow-600 dark:text-yellow-400'
      case 'Medium-High': return 'text-orange-600 dark:text-orange-400'
      case 'High': return 'text-red-600 dark:text-red-400'
      default: return 'text-gray-600 dark:text-gray-400'
    }
  }

  if (selectedStack) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-slate-50 to-blue-50 dark:from-slate-900 dark:to-slate-800">
        <div className="container mx-auto px-4 py-8">
          <div className="mb-6">
            <Button 
              variant="ghost" 
              onClick={() => setSelectedStack(null)}
              className="mb-4"
            >
              ← Back to Overview
            </Button>
            <div className="bg-white dark:bg-slate-800 rounded-lg shadow-lg p-8">
              <div className="flex items-start justify-between mb-6">
                <div>
                  <h1 className="text-4xl font-bold text-slate-900 dark:text-white mb-2">
                    {selectedStack.title}
                  </h1>
                  <p className="text-xl text-slate-600 dark:text-slate-300 mb-4">
                    {selectedStack.description}
                  </p>
                  <div className="flex flex-wrap gap-2 mb-4">
                    <Badge className={getUsageBadgeColor(selectedStack.usage)}>
                      {selectedStack.usage} Usage
                    </Badge>
                    <Badge variant="outline">
                      {selectedStack.category}
                    </Badge>
                    <Badge variant="outline">
                      <Star className="w-3 h-3 mr-1" />
                      {selectedStack.aiCompatibility} AI Compatibility
                    </Badge>
                    <Badge variant="outline">
                      {selectedStack.wordCount} words
                    </Badge>
                  </div>
                </div>
                <div className="text-right">
                  <div className="text-sm text-slate-500 dark:text-slate-400 mb-1">Complexity</div>
                  <div className={`text-lg font-semibold ${getComplexityColor(selectedStack.complexity)}`}>
                    {selectedStack.complexity}
                  </div>
                </div>
              </div>

              <div className="grid md:grid-cols-2 gap-8 mb-8">
                <div>
                  <h3 className="text-lg font-semibold mb-3 text-slate-900 dark:text-white">
                    Primary Technologies
                  </h3>
                  <div className="flex flex-wrap gap-2">
                    {selectedStack.primaryTech.map((tech, index) => (
                      <Badge key={index} variant="secondary" className="text-sm">
                        {tech}
                      </Badge>
                    ))}
                  </div>
                </div>
                <div>
                  <h3 className="text-lg font-semibold mb-3 text-slate-900 dark:text-white">
                    Examples
                  </h3>
                  <p className="text-slate-600 dark:text-slate-300">
                    {selectedStack.examples}
                  </p>
                </div>
              </div>

              <div className="mb-8">
                <h3 className="text-lg font-semibold mb-3 text-slate-900 dark:text-white">
                  Key Highlights
                </h3>
                <div className="grid md:grid-cols-2 gap-3">
                  {selectedStack.highlights.map((highlight, index) => (
                    <div key={index} className="flex items-start gap-2">
                      <ArrowRight className="w-4 h-4 text-blue-500 mt-0.5 flex-shrink-0" />
                      <span className="text-slate-600 dark:text-slate-300">{highlight}</span>
                    </div>
                  ))}
                </div>
              </div>

              <div className="bg-slate-50 dark:bg-slate-700 rounded-lg p-6">
                <h3 className="text-lg font-semibold mb-3 text-slate-900 dark:text-white">
                  Full Documentation
                </h3>
                <p className="text-slate-600 dark:text-slate-300 mb-4">
                  This tech stack includes comprehensive documentation covering architecture patterns, 
                  development environment setup, performance optimization, security best practices, 
                  testing strategies, and deployment guidelines specifically optimized for AI-assisted development.
                </p>
                <div className="flex gap-3">
                  <Button className="flex items-center gap-2">
                    <BookOpen className="w-4 h-4" />
                    View Full Guide
                  </Button>
                  <Button variant="outline" className="flex items-center gap-2">
                    <ExternalLink className="w-4 h-4" />
                    Download PDF
                  </Button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-50 to-blue-50 dark:from-slate-900 dark:to-slate-800">
      {/* Header */}
      <header className="bg-white dark:bg-slate-800 shadow-sm border-b border-slate-200 dark:border-slate-700">
        <div className="container mx-auto px-4 py-6">
          <div className="flex items-center justify-between">
            <div>
              <h1 className="text-3xl font-bold text-slate-900 dark:text-white">
                AI-Optimized Tech Stack Guide
              </h1>
              <p className="text-slate-600 dark:text-slate-300 mt-1">
                Comprehensive development resources for AI-assisted coding
              </p>
            </div>
            <div className="flex items-center gap-4">
              <Badge variant="outline" className="flex items-center gap-1">
                <Code className="w-3 h-3" />
                Claude Code
              </Badge>
              <Badge variant="outline" className="flex items-center gap-1">
                <Zap className="w-3 h-3" />
                Cursor
              </Badge>
              <Button variant="outline" size="sm" className="flex items-center gap-2">
                <Github className="w-4 h-4" />
                GitHub
              </Button>
            </div>
          </div>
        </div>
      </header>

      <div className="container mx-auto px-4 py-8">
        {/* Stats Overview */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
          <Card>
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm font-medium text-slate-600 dark:text-slate-400">
                    Completed Guides
                  </p>
                  <p className="text-2xl font-bold text-slate-900 dark:text-white">
                    8
                  </p>
                </div>
                <BookOpen className="w-8 h-8 text-blue-500" />
              </div>
            </CardContent>
          </Card>
          <Card>
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm font-medium text-slate-600 dark:text-slate-400">
                    Total Progress
                  </p>
                  <p className="text-2xl font-bold text-slate-900 dark:text-white">
                    20%
                  </p>
                </div>
                <TrendingUp className="w-8 h-8 text-green-500" />
              </div>
            </CardContent>
          </Card>
          <Card>
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm font-medium text-slate-600 dark:text-slate-400">
                    AI Compatible
                  </p>
                  <p className="text-2xl font-bold text-slate-900 dark:text-white">
                    100%
                  </p>
                </div>
                <Star className="w-8 h-8 text-yellow-500" />
              </div>
            </CardContent>
          </Card>
          <Card>
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm font-medium text-slate-600 dark:text-slate-400">
                    Categories
                  </p>
                  <p className="text-2xl font-bold text-slate-900 dark:text-white">
                    4
                  </p>
                </div>
                <Layers className="w-8 h-8 text-purple-500" />
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Search and Filters */}
        <div className="bg-white dark:bg-slate-800 rounded-lg shadow-sm p-6 mb-8">
          <div className="flex flex-col md:flex-row gap-4">
            <div className="flex-1">
              <div className="relative">
                <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-slate-400 w-4 h-4" />
                <Input
                  placeholder="Search tech stacks, frameworks, or technologies..."
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  className="pl-10"
                />
              </div>
            </div>
            <div className="flex gap-2">
              <select
                value={selectedCategory}
                onChange={(e) => setSelectedCategory(e.target.value)}
                className="px-3 py-2 border border-slate-300 dark:border-slate-600 rounded-md bg-white dark:bg-slate-700 text-slate-900 dark:text-white"
              >
                <option value="all">All Categories</option>
                <option value="web-applications">Web Applications</option>
                <option value="mobile-desktop-cli">Mobile & Desktop</option>
                <option value="api-backend-games">API & Backend</option>
                <option value="specialized-apps">Specialized</option>
              </select>
              <select
                value={selectedUsage}
                onChange={(e) => setSelectedUsage(e.target.value)}
                className="px-3 py-2 border border-slate-300 dark:border-slate-600 rounded-md bg-white dark:bg-slate-700 text-slate-900 dark:text-white"
              >
                <option value="all">All Usage Levels</option>
                <option value="High">High Usage</option>
                <option value="Medium">Medium Usage</option>
                <option value="Low">Low Usage</option>
              </select>
            </div>
          </div>
        </div>

        {/* Tech Stack Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {filteredStacks.map((stack) => (
            <Card 
              key={stack.id} 
              className="hover:shadow-lg transition-shadow cursor-pointer group"
              onClick={() => setSelectedStack(stack)}
            >
              <CardHeader>
                <div className="flex items-start justify-between">
                  <div className="flex-1">
                    <CardTitle className="text-lg group-hover:text-blue-600 dark:group-hover:text-blue-400 transition-colors">
                      {stack.title}
                    </CardTitle>
                    <CardDescription className="mt-1">
                      {stack.examples}
                    </CardDescription>
                  </div>
                  <ArrowRight className="w-4 h-4 text-slate-400 group-hover:text-blue-500 transition-colors" />
                </div>
              </CardHeader>
              <CardContent>
                <p className="text-sm text-slate-600 dark:text-slate-300 mb-4">
                  {stack.description}
                </p>
                
                <div className="flex flex-wrap gap-2 mb-4">
                  <Badge className={getUsageBadgeColor(stack.usage)}>
                    {stack.usage}
                  </Badge>
                  <Badge variant="outline">
                    <Star className="w-3 h-3 mr-1" />
                    {stack.aiCompatibility}
                  </Badge>
                </div>

                <div className="mb-4">
                  <div className="text-xs text-slate-500 dark:text-slate-400 mb-1">
                    Primary Technologies
                  </div>
                  <div className="flex flex-wrap gap-1">
                    {stack.primaryTech.slice(0, 3).map((tech, index) => (
                      <Badge key={index} variant="secondary" className="text-xs">
                        {tech}
                      </Badge>
                    ))}
                    {stack.primaryTech.length > 3 && (
                      <Badge variant="secondary" className="text-xs">
                        +{stack.primaryTech.length - 3} more
                      </Badge>
                    )}
                  </div>
                </div>

                <div className="flex items-center justify-between text-sm">
                  <span className="text-slate-500 dark:text-slate-400">
                    {stack.wordCount} words
                  </span>
                  <span className={`font-medium ${getComplexityColor(stack.complexity)}`}>
                    {stack.complexity} complexity
                  </span>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>

        {filteredStacks.length === 0 && (
          <div className="text-center py-12">
            <div className="text-slate-400 dark:text-slate-500 mb-2">
              <Search className="w-12 h-12 mx-auto mb-4" />
            </div>
            <h3 className="text-lg font-medium text-slate-900 dark:text-white mb-2">
              No tech stacks found
            </h3>
            <p className="text-slate-600 dark:text-slate-300">
              Try adjusting your search terms or filters
            </p>
          </div>
        )}

        {/* Footer */}
        <footer className="mt-16 pt-8 border-t border-slate-200 dark:border-slate-700">
          <div className="text-center text-slate-600 dark:text-slate-300">
            <p className="mb-2">
              Comprehensive tech stack guides optimized for AI-assisted development
            </p>
            <p className="text-sm">
              Compatible with Claude Code, Cursor, GitHub Copilot, and other AI coding tools
            </p>
          </div>
        </footer>
      </div>
    </div>
  )
}

export default App

