using AutoMapper;
using FluentValidation;

using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure;
using eCinema.Infrastructure.Interfaces;
using eCinema.Infrastructure.Interfaces.SearchObjects;

namespace eCinema.Application
{
    public class ProductionsService : BaseService<Production, ProductionDto, ProductionUpsertDto, ProductionSearchObject, IProductionsRepository>, IProductionsService
    {
        public ProductionsService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<ProductionUpsertDto> validator) : base(mapper, unitOfWork, validator)
        {
        }
    }
}
