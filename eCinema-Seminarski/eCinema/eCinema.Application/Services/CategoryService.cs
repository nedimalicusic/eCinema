using AutoMapper;
using eCinema.Application.Interfaces.Services;
using eCinema.Core;
using eCinema.Core.Entities;
using eCinema.Infrastructure;
using eCinema.Infrastructure.Interfaces;
using eCinema.Infrastructure.Interfaces.Repositories;
using FluentValidation;

namespace eCinema.Application.Services
{
    public class CategoryService : BaseService<Category, CategoryDto, CategoryUpsertDto, BaseSearchObject, ICategoryRepository>, ICategoryService
    {
        public CategoryService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<CategoryUpsertDto> validator) : base(mapper, unitOfWork, validator)
        {
        }
    }
}
