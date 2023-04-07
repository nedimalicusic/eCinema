using AutoMapper;
using FluentValidation;

using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Application
{
    public class GenresService : BaseService<Genre, GenreDto, GenreUpsertDto, BaseSearchObject, IGenresRepository>, IGenresService
    {
        public GenresService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<GenreUpsertDto> validator) : base(mapper, unitOfWork, validator)
        {
        }
    }
}
