﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Razor;
using System.IO;
using System.Reflection;
using System.CodeDom;
using System.CodeDom.Compiler;
using Microsoft.CSharp;
using System.Dynamic;
using System.Security.Cryptography;

namespace Cms.Helpers
{
    public class RazorEngine
    {
        // TODO: Cache compiled dynamic assembly for performance reasons
        public static string GetContent(string template, dynamic model)
        {
            if (string.IsNullOrEmpty(template)) { return string.Empty; }

            const string dynamicallyGeneratedClassName = "DynamicContentTemplate";
            const string namespaceForDynamicClasses = "dyn";
            const string dynamicClassFullName = namespaceForDynamicClasses + "." + dynamicallyGeneratedClassName;

            var assembly = default(Assembly);

            string assemblyFileName = Path.Combine(Path.GetTempPath(), "CompiledRazor.{0}.dll".FormatWith(Hash(template)));
            if (File.Exists(assemblyFileName))
            {
                assembly = Assembly.LoadFrom(assemblyFileName);
            }
            else
            {
                var language = new CSharpRazorCodeLanguage();
                var host = new RazorEngineHost(language)
                {
                    DefaultBaseClass = typeof(DynamicContentGeneratorBase).FullName,
                    DefaultClassName = dynamicallyGeneratedClassName,
                    DefaultNamespace = namespaceForDynamicClasses,
                };
                host.NamespaceImports.Add("System");
                host.NamespaceImports.Add("System.Dynamic");
                host.NamespaceImports.Add("System.Text");
                var engine = new RazorTemplateEngine(host);

                var tr = new StringReader(template); // here is where the string come in place
                GeneratorResults razorTemplate = engine.GenerateCode(tr);

                var compilerParameters = new CompilerParameters();
                AppDomain.CurrentDomain.GetAssemblies()
                    .Where(a => !a.IsDynamic)
                    .ToList()
                    .ForEach(a => compilerParameters.ReferencedAssemblies.Add(a.Location));
                compilerParameters.OutputAssembly = assemblyFileName;
                compilerParameters.TempFiles = new TempFileCollection(Path.GetTempPath(), true);

                CompilerResults compilerResults = new CSharpCodeProvider().CompileAssemblyFromDom(compilerParameters, razorTemplate.GeneratedCode);
                if (compilerResults.Errors.Count > 0)
                {
                    return "Error: " + string.Join("\r\nError: ", compilerResults.Errors.Cast<CompilerError>().Select(e => e.ErrorText));
                }
                assembly = compilerResults.CompiledAssembly;
            }

            var templateInstance = (DynamicContentGeneratorBase)assembly.CreateInstance(dynamicClassFullName);

            templateInstance.Model = model;

            try
            {
                return templateInstance.GetContent();
            }
            catch(Exception e)
            {
                return "Error: " + e.Message;
            }
        }

        private static string Hash(string input)
        {
            var bytes = input.ToCharArray().SelectMany(c => BitConverter.GetBytes(c)).ToArray();

            var sb = new StringBuilder();
            var alg = MD5.Create();
            foreach (var b in alg.ComputeHash(bytes, 0, bytes.Length))
            {
                sb.AppendFormat("{0:X}", b);
            }
            return sb.ToString();
        }
    }



    public abstract class DynamicContentGeneratorBase
    {
        private StringBuilder buffer;
        protected DynamicContentGeneratorBase()
        {
            Model = new ExpandoObject();
        }

        /// <summary>
        /// This is just a custom property
        /// </summary>
        public dynamic Model { get; set; }

        /// <summary>
        /// This method is required and have to be exactly as declared here.
        /// </summary>
        public abstract void Execute();

        /// <summary>
        /// This method is required and can be public but have to have exactly the same signature
        /// </summary>
        protected void Write(object value)
        {
            WriteLiteral(value);
        }

        /// <summary>
        /// This method is required and can be public but have to have exactly the same signature
        /// </summary>
        protected void WriteLiteral(object value)
        {
            buffer.Append(value);
        }

        /// <summary>
        /// This method is just to have the rendered content without call Execute.
        /// </summary>
        /// <returns>The rendered content.</returns>
        public string GetContent()
        {
            buffer = new StringBuilder(1024);
            Execute();
            return buffer.ToString();
        }
    }
}
