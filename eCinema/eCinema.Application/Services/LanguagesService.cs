using AutoMapper;
using FluentValidation;

using eCinema.Application.Interfaces;
using eCinema.Core;
using eCinema.Infrastructure;
using eCinema.Infrastructure.Interfaces;

namespace eCinema.Application
{
    public class LanguagesService : BaseService<Language, LanguageDto, LanguageUpsertDto, BaseSearchObject, ILanguagesRepository>, ILanguagesService
    {
        public LanguagesService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<LanguageUpsertDto> validator) : base(mapper, unitOfWork, validator)
        {
        }
    }
}
