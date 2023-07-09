//
//  TailwindCSS.swift
//  CAOCAP
//
//  Created by Azzam AL-Rashed on 09/07/2023.
//

import Foundation

let tailwindCSS = [
    // MARK: Layout
    
    /* Aspect Ratio */
    "aspect-auto","aspect-video","aspect-square",
    
    /* Container */
    "container","mx-auto","max-width","min-width",
    
    /* Columns */
    "columns-1","columns-2","columns-3","columns-4","columns-5","columns-6","columns-7","columns-8","columns-9","columns-10","columns-11","columns-12","columns-auto","columns-3xs","columns-2xs","columns-xs","columns-sm","columns-md","columns-lg","columns-xl","columns-2xl","columns-3xl","columns-4xl","columns-5xl","columns-6xl","columns-7xl",
    
    
    /* Break After */
    "break-after-auto","break-after-avoid","break-after-all","break-after-avoid-page","break-after-page","break-after-left","break-after-right","break-after-column",
    
    /* Break Before */
    "break-before-auto","break-before-avoid","break-before-all","break-before-avoid-page","break-before-page","break-before-left","break-before-right","break-before-column",
    
    /* Break Inside */
    "break-inside-auto","break-inside-avoid","break-inside-avoid-page","break-inside-avoid-column",
    
    /* Box Decoration Break */
    "box-decoration-clone","box-decoration-slice",
    
    /* Box Sizing */
    "box-border","box-content",
    
    /* Display */
    "block","inline-block","inline","flex","inline-flex","table","inline-table","table-caption","table-cell","table-column","table-column-group","table-footer-group","table-header-group","table-row-group","table-row","flow-root","grid","inline-grid","contents","list-item","hidden",
    
    /* Floats */
    "float-right","float-left","float-none",
    
    /* Clear */
    "clear-left","clear-right","clear-both","clear-none",
    
    /* Isolation */
    "isolate","isolation-auto",
    
    /* Object Fit */
    "object-contain","object-cover","object-fill","object-none","object-scale-down",
    
    /* Object Position */
    "object-bottom","object-center","object-left","object-left-bottom","object-left-top","object-right","object-right-bottom","object-right-top","object-top",
    
    /* Overflow */
    "overflow-auto","overflow-hidden","overflow-clip","overflow-visible","overflow-scroll","overflow-x-auto","overflow-y-auto","overflow-x-hidden","overflow-y-hidden","overflow-x-clip","overflow-y-clip","overflow-x-visible","overflow-y-visible","overflow-x-scroll","overflow-y-scroll",
    
    /* Overscroll Behavior */
    "overscroll-auto","overscroll-contain","overscroll-none","overscroll-y-auto","overscroll-y-contain","overscroll-y-none","overscroll-x-auto","overscroll-x-contain","overscroll-x-none",
    
    /* Position */
    "static","fixed","absolute","relative","sticky",
    
    
    /* Top / Right / Bottom / Left */
    "inset-px","inset-x-px","inset-y-px","start-px","end-px","top-px","right-px","bottom-px","left-px",
    "inset-0","inset-x-0","inset-y-0","start-0","end-0","top-0","right-0","bottom-0","left-0",
    "inset-0.5","inset-x-0.5","inset-y-0.5","start-0.5","end-0.5","top-0.5","right-0.5","bottom-0.5","left-0.5",
    "inset-1","inset-x-1","inset-y-1","start-1","end-1","top-1","right-1","bottom-1","left-1",
    "inset-1.5","inset-x-1.5","inset-y-1.5","start-1.5","end-1.5","top-1.5","right-1.5","bottom-1.5","left-1.5",
    "inset-2","inset-x-2","inset-y-2","start-2","end-2","top-2","right-2","bottom-2","left-2",
    "inset-2.5","inset-x-2.5","inset-y-2.5","start-2.5","end-2.5","top-2.5","right-2.5","bottom-2.5","left-2.5",
    "inset-3","inset-x-3","inset-y-3","start-3","end-3","top-3","right-3","bottom-3","left-3",
    "inset-3.5","inset-x-3.5","inset-y-3.5","start-3.5","end-3.5","top-3.5","right-3.5","bottom-3.5","left-3.5",
    "inset-4","inset-x-4","inset-y-4","start-4","end-4","top-4","right-4","bottom-4","left-4",
    "inset-5","inset-x-5","inset-y-5","start-5","end-5","top-5","right-5","bottom-5","left-5",
    "inset-6","inset-x-6","inset-y-6","start-6","end-6","top-6","right-6","bottom-6","left-6",
    "inset-7","inset-x-7","inset-y-7","start-7","end-7","top-7","right-7","bottom-7","left-7",
    "inset-8","inset-x-8","inset-y-8","start-8","end-8","top-8","right-8","bottom-8","left-8",
    "inset-9","inset-x-9","inset-y-9","start-9","end-9","top-9","right-9","bottom-9","left-9",
    "inset-10","inset-x-10","inset-y-10","start-10","end-10","top-10","right-10","bottom-10","left-10",
    "inset-11","inset-x-11","inset-y-11","start-11","end-11","top-11","right-11","bottom-11","left-11",
    "inset-12","inset-x-12","inset-y-12","start-12","end-12","top-12","right-12","bottom-12","left-12",
    "inset-14","inset-x-14","inset-y-14","start-14","end-14","top-14","right-14","bottom-14","left-14",
    "inset-16","inset-x-16","inset-y-16","start-16","end-16","top-16","right-16","bottom-16","left-16",
    "inset-20","inset-x-20","inset-y-20","start-20","end-20","top-20","right-20","bottom-20","left-20",
    "inset-24","inset-x-24","inset-y-24","start-24","end-24","top-24","right-24","bottom-24","left-24",
    "inset-28","inset-x-28","inset-y-28","start-28","end-28","top-28","right-28","bottom-28","left-28",
    "inset-32","inset-x-32","inset-y-32","start-32","end-32","top-32","right-32","bottom-32","left-32",
    "inset-36","inset-x-36","inset-y-36","start-36","end-36","top-36","right-36","bottom-36","left-36",
    "inset-44","inset-x-44","inset-y-44","start-44","end-44","top-44","right-44","bottom-44","left-44",
    "inset-48","inset-x-48","inset-y-48","start-48","end-48","top-48","right-48","bottom-48","left-48",
    "inset-52","inset-x-52","inset-y-52","start-52","end-52","top-52","right-52","bottom-52","left-52",
    "inset-56","inset-x-56","inset-y-56","start-56","end-56","top-56","right-56","bottom-56","left-56",
    "inset-60","inset-x-60","inset-y-60","start-60","end-60","top-60","right-60","bottom-60","left-60",
    "inset-64","inset-x-64","inset-y-64","start-64","end-64","top-64","right-64","bottom-64","left-64",
    "inset-72","inset-x-72","inset-y-72","start-72","end-72","top-72","right-72","bottom-72","left-72",
    "inset-80","inset-x-80","inset-y-80","start-80","end-80","top-80","right-80","bottom-80","left-80",
    "inset-96","inset-x-96","inset-y-96","start-96","end-96","top-96","right-96","bottom-96","left-96",
    
    "inset-auto","inset-1/2","inset-1/3","inset-2/3","inset-1/4","inset-2/4","inset-3/4","inset-full",
    
    "inset-x-auto","inset-x-1/2","inset-x-1/3","inset-x-2/3","inset-x-1/4","inset-x-2/4","inset-x-3/4","inset-x-full",
    
    "inset-y-auto","inset-y-1/2","inset-y-1/3","inset-y-2/3","inset-y-1/4","inset-y-2/4","inset-y-3/4","inset-y-full",
    
    "start-auto","start-1/2","start-1/3","start-2/3","start-1/4","start-2/4","start-3/4","start-full",
    
    "end-auto","end-1/2","end-1/3","end-2/3","end-1/4","end-2/4","end-3/4","end-full",
    
    "top-auto","top-1/2","top-1/3","top-2/3","top-1/4","top-2/4","top-3/4","top-full",
    
    "right-auto","right-1/2","right-1/3","right-2/3","right-1/4","right-2/4","right-3/4","right-full",
    
    "bottom-auto","bottom-1/2","bottom-1/3","bottom-2/3","bottom-1/4","bottom-2/4","bottom-3/4","bottom-full",

    "left-auto","left-1/2","left-1/3","left-2/3","left-1/4","left-2/4","left-3/4","left-full",
    
    /* Visibility */
    "visible","invisible","collapse",
    
    /* Z-Index */
    "z-0","z-10","z-20","z-30","z-40","z-50","z-auto",
    
    // MARK: Flexbox & Grid
    
    /* Flex Basis */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Flex Direction */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Flex Wrap */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Flex */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Flex Grow */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Flex Shrink */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Order */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Grid Template Columns */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Grid Column Start / End */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Grid Template Rows */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Grid Row Start / End */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Grid Auto Flow */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Grid Auto Columns */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Grid Auto Rows */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Gap */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Justify Content */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Justify Items */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Justify Self */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Align Content */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Align Items */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Align Self */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Place Content */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Place Items */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Place Self */
    "","","","","","","","","","","","","","","","","","","",
    
    
    // MARK: Spacing
    
    /* Padding */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Margin */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Space Between */
    "","","","","","","","","","","","","","","","","","","",
    
    
    // MARK: Sizing
    
    /* Width */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Min-Width */
    "min-w-0","min-w-full","min-w-min","min-w-max","min-w-fit",
    
    /* Max-Width */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Height */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Min-Height */
    "min-h-0","min-h-full","min-h-screen","min-h-min","min-h-max","min-h-fit",
    
    /* Max-Height */
    "","","","","","","","","","","","","","","","","","","",
    
    
    // MARK: Typography
    
    /* Font Family */
    "font-sans","font-serif","font-mono",
    
    /* Font Size */
    "text-xs","text-sm","text-base","text-lg","text-xl","text-2xl","text-3xl","text-4xl","text-5xl","text-6xl","text-7xl","text-8xl","text-9xl",
    
    /* Font Smoothing */
    "antialiased","subpixel-antialiased",
    
    /* Font Style */
    "italic","not-italic",
    
    /* Font Weight */
    "font-thin","font-extralight","font-light","font-normal","font-medium","font-semibold","font-bold","font-extrabold","font-black",
    
    /* Font Variant Numeric */
    "normal-nums","ordinal","slashed-zero","lining-nums","oldstyle-nums","proportional-nums","tabular-nums","diagonal-fractions","stacked-fractions",
    
    /* Letter Spacing */
    "tracking-tighter","tracking-tight","tracking-normal","tracking-wide","tracking-wider","tracking-widest",
    
    /* Line Clamp */
    "line-clamp-1","line-clamp-2","line-clamp-3","line-clamp-4","line-clamp-5","line-clamp-6","line-clamp-none",
    
    /* Line Height */
    "leading-3","leading-4","leading-5","leading-6","leading-7","leading-8","leading-9","leading-10","leading-none","leading-tight","leading-snug","leading-normal","leading-relaxed","leading-loose",
    
    /* List Style Image */
    "list-image-none",
    
    /* List Style Position */
    "list-inside","list-outside",
    
    /* List Style Type */
    "list-none","list-disc","list-decimal",
    
    /* Text Align */
    "text-left","text-center","text-right","text-justify","text-start","text-end",
    
    /* Text Color */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Text Decoration */
    "underline","overline","line-through","no-underline",
    
    /* Text Decoration Color */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Text Decoration Style */
    "decoration-solid","decoration-double","decoration-dotted","decoration-dashed","decoration-wavy",
    
    /* Text Decoration Thickness */
    "decoration-auto","decoration-from-font","decoration-0","decoration-1","decoration-2","decoration-4","decoration-8",
    
    /* Text Underline Offset */
    "underline-offset-auto","underline-offset-0","underline-offset-1","underline-offset-2","underline-offset-4","underline-offset-8",
    
    /* Text Transform */
    "uppercase","lowercase","capitalize","normal-case",
    
    /* Text Overflow */
    "truncate","text-ellipsis","text-clip",
    
    /* Text Indent */
    "","","","","","","","","","","","","","","","","","",
    
    /* Vertical Align */
    "align-baseline","align-top","align-middle","align-bottom","align-text-top","align-text-bottom","align-sub","align-super",
    
    /* Whitespace */
    "whitespace-normal","whitespace-nowrap","whitespace-pre","whitespace-pre-line","whitespace-pre-wrap","whitespace-break-spaces",
    
    /* Word Break */
    "break-normal","break-words","break-all","break-keep",
    
    /* Hyphens */
    "hyphens-none","hyphens-manual","hyphens-auto",
    
    /* Content */
    "content-none",
    
    
    // MARK: Backgrounds
    
    /* Background Attachment */
    "bg-fixed","bg-local","bg-scroll",
    
    /* Background Clip */
    "bg-clip-border","bg-clip-padding","bg-clip-content","bg-clip-text",
    
    /* Background Color */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Background Origin */
    "bg-origin-border","bg-origin-padding","bg-origin-content",
    
    /* Background Position */
    "bg-bottom","bg-center","bg-left","bg-left-bottom","bg-left-top","bg-right","bg-right-bottom","bg-right-top","bg-top",
    
    /* Background Repeat */
    "bg-repeat","bg-no-repeat","bg-repeat-x","bg-repeat-y","bg-repeat-round","bg-repeat-space",
    
    /* Background Size */
    "bg-auto","bg-cover","bg-contain",
    
    /* Background Image */
    "bg-none","bg-gradient-to-t","bg-gradient-to-tr","bg-gradient-to-r","bg-gradient-to-br","bg-gradient-to-b","bg-gradient-to-bl","bg-gradient-to-l","bg-gradient-to-tl",
    
    /* Gradient Color Stops */
    "from-inherit","from-current","from-transparent","from-black",
    
    
    // MARK: Borders
    
    /* Border Radius */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Border Width */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Border Color */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Border Style */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Divide Width */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Divide Color */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Divide Style */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Outline Width */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Outline Color */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Outline Style */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Outline Offset */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Ring Width */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Ring Color */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Ring Offset Width */
    "ring-offset-0","ring-offset-1","ring-offset-2","ring-offset-4","ring-offset-8",
    
    /* Ring Offset Color */
    "","","","","","","","","","","","","","","","","","","",
    
    // MARK: Effects
    
    /* Box Shadow */
    "shadow-sm","shadow","shadow-md","shadow-lg","shadow-xl","shadow-2xl","shadow-inner","shadow-none",
    
    /* Box Shadow Color */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Opacity */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Mix Blend Mode */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Background Blend Mode */
    "","","","","","","","","","","","","","","","","","","",
    
    
    // MARK: Filters
    
    /* Blur */
    "blur-none","blur-sm","blur","blur-md","blur-lg","blur-xl","blur-2xl","blur-3xl",
    
    /* Brightness */
    "brightness-0","brightness-50","brightness-75","brightness-90","brightness-95","brightness-100","brightness-105","brightness-110","brightness-125","brightness-150","brightness-200",
    
    /* Contrast */
    "contrast-0","contrast-50","contrast-75","contrast-100","contrast-125","contrast-150","contrast-200",
    
    /* Drop Shadow */
    "drop-shadow-sm","drop-shadow","drop-shadow-md","drop-shadow-lg","drop-shadow-xl","drop-shadow-2xl","drop-shadow-none",
    
    /* Grayscale */
    "grayscale-0","grayscale",
    
    /* Hue Rotate */
    "hue-rotate-0","hue-rotate-15","hue-rotate-30","hue-rotate-60","hue-rotate-90","hue-rotate-180",
    
    /* Invert */
    "invert-0","invert",
    
    /* Saturate */
    "saturate-0","saturate-50","saturate-100","saturate-150","saturate-200",
    
    /* Sepia */
    "sepia-0","sepia",
    
    /* Backdrop Blur */
    "backdrop-blur-none","backdrop-blur-sm","backdrop-blur","backdrop-blur-md","backdrop-blur-lg","backdrop-blur-xl","backdrop-blur-2xl","backdrop-blur-3xl",
    
    /* Backdrop Brightness */
    "backdrop-brightness-0","backdrop-brightness-50","backdrop-brightness-75","backdrop-brightness-90","backdrop-brightness-95","backdrop-brightness-100","backdrop-brightness-105","backdrop-brightness-110","backdrop-brightness-125","backdrop-brightness-150","backdrop-brightness-200",
    
    /* Backdrop Contrast */
    "backdrop-contrast-0","backdrop-contrast-50","backdrop-contrast-75","backdrop-contrast-100","backdrop-contrast-125","backdrop-contrast-150","backdrop-contrast-200",
    
    /* Backdrop Grayscale */
    "backdrop-grayscale-0","backdrop-grayscale",
    
    /* Backdrop Hue Rotate */
    "backdrop-hue-rotate-0","backdrop-hue-rotate-15","backdrop-hue-rotate-30","backdrop-hue-rotate-60","backdrop-hue-rotate-90","backdrop-hue-rotate-180",
    
    /* Backdrop Invert */
    "backdrop-invert-0","backdrop-invert",
    
    /* Backdrop Opacity */
    "backdrop-opacity-0","backdrop-opacity-5","backdrop-opacity-10","backdrop-opacity-20","backdrop-opacity-25","backdrop-opacity-30","backdrop-opacity-40","backdrop-opacity-50","backdrop-opacity-60","backdrop-opacity-70","backdrop-opacity-75","backdrop-opacity-80","backdrop-opacity-90","backdrop-opacity-95","backdrop-opacity-100",
    
    /* Backdrop Saturate */
    "backdrop-saturate-0","backdrop-saturate-50","backdrop-saturate-100","backdrop-saturate-150","backdrop-saturate-200",
    
    /* Backdrop Sepia */
    "backdrop-sepia-0","backdrop-sepia",
    
    // MARK: Tables
    
    /* Border Collapse */
    "border-collapse","border-separate",
    
    /* Border Spacing */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Table Layout */
    "table-auto","table-fixed",
    
    /* Caption Side */
    "caption-top","caption-bottom",
    
    // MARK: Transitions & Animation
    
    /* Transition Property */
    "transition-none","transition-all","transition","transition-colors","transition-opacity","transition-shadow","transition-transform",
    
    /* Transition Duration */
    "duration-0","duration-75","duration-100","duration-150","duration-200","duration-300","duration-500","duration-700","duration-1000",
    
    /* Transition Timing Function */
    "ease-linear","ease-in","ease-out","ease-in-out",
    
    /* Transition Delay */
    "delay-0","delay-75","delay-100","delay-150","delay-200","delay-300","delay-500","delay-700","delay-1000",
    
    /* Animation */
    "animate-none","animate-spin","animate-ping","animate-pulse","animate-bounce",
    
    
    // MARK: Transforms
    
    /* Scale */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Rotate */
    "rotate-0","rotate-1","rotate-2","rotate-3","rotate-6","rotate-12","rotate-45","rotate-90","rotate-180",
    
    /* Translate */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Skew */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Transform Origin */
    "origin-center","origin-top","origin-top-right","origin-right","origin-bottom-right","origin-bottom","origin-bottom-left","origin-left","origin-top-left",
    
    // MARK: Interactivity
    
    /* Accent Color */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Appearance */
    "appearance-none",
    
    /* Cursor */
    "cursor-auto","cursor-default","cursor-pointer","cursor-wait","cursor-text","cursor-move","cursor-help","cursor-not-allowed","cursor-none","cursor-context-menu","cursor-progress","cursor-cell","cursor-crosshair","cursor-vertical-text","cursor-alias","cursor-copy","cursor-no-drop","cursor-grab","cursor-grabbing","cursor-all-scroll","cursor-col-resize","cursor-row-resize","cursor-n-resize","cursor-e-resize","cursor-s-resize","cursor-w-resize","cursor-ne-resize","cursor-nw-resize","cursor-se-resize","cursor-sw-resize","cursor-ew-resize","cursor-ns-resize","cursor-nesw-resize","cursor-nwse-resize","cursor-zoom-in","cursor-zoom-out",
    
    /* Caret Color */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Pointer Events */
    "pointer-events-none","pointer-events-auto",
    
    /* Resize */
    "resize-none","resize-y","resize-x","resize",
    
    /* Scroll Behavior */
    "scroll-auto","scroll-smooth",
    
    /* Scroll Margin */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Scroll Padding */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Scroll Snap Align */
    "snap-start","snap-end","snap-center","snap-align-none",
    
    /* Scroll Snap Stop */
    "snap-normal","snap-always",
    
    /* Scroll Snap Type */
    "snap-none","snap-x","snap-y","snap-both","snap-mandatory","snap-proximity",
    
    /* Touch Action */
    "touch-auto","touch-none","touch-pan-x","touch-pan-left","touch-pan-right","touch-pan-y","touch-pan-up","touch-pan-down","touch-pinch-zoom","touch-manipulation",
    
    /* User Select */
    "select-none","select-text","select-all","select-auto",
    
    /* Will Change */
    "will-change-auto","will-change-scroll","will-change-contents","will-change-transform",
    
    // MARK: SVG
    
    /* Fill */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Stroke */
    "","","","","","","","","","","","","","","","","","","",
    
    /* Stroke Width */
    "stroke-0","stroke-1","stroke-2",
    
    // MARK: Accessibility
    
    /* Screen Readers */
    "sr-only","not-sr-only",
    
    
]
