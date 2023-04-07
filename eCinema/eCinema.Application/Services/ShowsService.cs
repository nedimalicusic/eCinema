using AutoMapper;
using FluentValidation;

using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Application
{
    public class ShowsService : BaseService<Show, ShowDto, ShowUpsertDto, BaseSearchObject, IShowsRepository>, IShowsService
    {
        public ShowsService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<ShowUpsertDto> validator) : base(mapper, unitOfWork, validator)
        {
        }
    }
}
