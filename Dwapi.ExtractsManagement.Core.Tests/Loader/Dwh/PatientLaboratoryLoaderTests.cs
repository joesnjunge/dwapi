﻿using System;
using System.Linq;
using Dwapi.ExtractsManagement.Core.Interfaces.Cleaner.Cbs;
using Dwapi.ExtractsManagement.Core.Interfaces.Loaders.Dwh;
using Dwapi.ExtractsManagement.Core.Interfaces.Utilities;
using Dwapi.ExtractsManagement.Core.Model.Destination.Dwh;
using Dwapi.ExtractsManagement.Core.Model.Source.Dwh;
using Dwapi.ExtractsManagement.Infrastructure;
using Dwapi.SharedKernel.Model;
using Dwapi.SharedKernel.Utility;
using FizzWare.NBuilder;
using Microsoft.Extensions.DependencyInjection;
using NUnit.Framework;

namespace Dwapi.ExtractsManagement.Core.Tests.Loader.Dwh
{
    [TestFixture]
    public class PatientLaboratoryLoaderTests
    {
        private ExtractsContext _extractsContext, _extractsContextMySql;
        private DbProtocol _iQtoolsDb, _kenyaEmrDb;
        [OneTimeSetUp]
        public void Init()
        {
            var extractIds = TestInitializer.Iqtools.Extracts.Where(x => x.DocketId.IsSameAs("NDWH")).Select(x => x.Id)
                .ToList();
            var cleaner = TestInitializer.ServiceProvider.GetService<IClearDwhExtracts>();
            cleaner.Clear(extractIds);

            var extractIdsMySql = TestInitializer.KenyaEmr.Extracts.Where(x => x.DocketId.IsSameAs("NDWH")).Select(x => x.Id)
                .ToList();
            var cleanerMySql = TestInitializer.ServiceProviderMysql.GetService<IClearDwhExtracts>();
            cleanerMySql.Clear(extractIdsMySql);

            _extractsContext = TestInitializer.ServiceProvider.GetService<ExtractsContext>();
            _extractsContextMySql = TestInitializer.ServiceProviderMysql.GetService<ExtractsContext>();

            var patients = Builder<PatientExtract>.CreateListOfSize(1).All().With(x => x.SiteCode = 1).With(x => x.PatientPK = 1).Build().ToList();
            var tempMpis = Builder<TempPatientLaboratoryExtract>.CreateListOfSize(1).All().With(x => x.SiteCode = 1).With(x => x.PatientPK = 1).With(x => x.CheckError = false).Build().ToList();

            _extractsContext.PatientExtracts.AddRange(patients);
            _extractsContext.TempPatientLaboratoryExtracts.AddRange(tempMpis);
            _extractsContext.SaveChanges();

            _extractsContextMySql.PatientExtracts.AddRange(patients);
            _extractsContextMySql.TempPatientLaboratoryExtracts.AddRange(tempMpis);
            _extractsContextMySql.SaveChanges();

            _iQtoolsDb = TestInitializer.Iqtools.DatabaseProtocols.First(x => x.DatabaseName.ToLower().Contains("iqtools".ToLower()));
            _iQtoolsDb.Host = "192.168.100.99\\Koske14";
            _iQtoolsDb.Username = "sa";
            _iQtoolsDb.Password = "maun";

            _kenyaEmrDb = TestInitializer.KenyaEmr.DatabaseProtocols.First();
            _kenyaEmrDb.Host = "192.168.100.99";
            _kenyaEmrDb.Username = "root";
            _kenyaEmrDb.Password = "root";
            _kenyaEmrDb.DatabaseName = "openmrs";
        }


        [Test]
        public void should_Load_From_Temp_MsSQL()
        {
            Assert.False(_extractsContext.PatientLaboratoryExtracts.Any());
            var extract = TestInitializer.Iqtools.Extracts.First(x => x.Name.IsSameAs("PatientLabExtract"));

            var loader = TestInitializer.ServiceProvider.GetService<IPatientLaboratoryLoader>();

            var loadCount = loader.Load(extract.Id, 0).Result;
            Assert.True(_extractsContext.PatientLaboratoryExtracts.Any());
            Console.WriteLine($"extracted {_extractsContext.PatientLaboratoryExtracts.Count()}");
        }

        [Test]
        public void should_Load_From_Temp_MySQL()
        {
            Assert.False(_extractsContextMySql.PatientLaboratoryExtracts.Any());
            var extract = TestInitializer.KenyaEmr.Extracts.First(x => x.Name.IsSameAs("PatientLabExtract"));

            var loader = TestInitializer.ServiceProviderMysql.GetService<IPatientLaboratoryLoader>();

            var loadCount = loader.Load(extract.Id, 0).Result;
            Assert.True(_extractsContextMySql.PatientLaboratoryExtracts.Any());
            Console.WriteLine($"extracted {_extractsContextMySql.PatientLaboratoryExtracts.Count()}");
        }
    }
}